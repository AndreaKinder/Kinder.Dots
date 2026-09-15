import {
  Action,
  ActionPanel,
  Icon,
  List,
  showToast,
  Toast,
} from "@raycast/api";
import { execFile } from "node:child_process";
import { promisify } from "node:util";
import { readdir } from "node:fs/promises";
import path from "node:path";

const execFileAsync = promisify(execFile);
const VAULT = "/Volumes/Files/notes";
const JOURNAL = path.join(VAULT, "journal");
const SCRIPT = `${process.env.HOME}/.dotfiles/scripts/raycast/exportar-notas-apple-notes.sh`;

type Entry = {
  name: string;
  path: string;
  relativePath: string;
  directory: boolean;
};

async function getEntries(): Promise<Entry[]> {
  const entries: Entry[] = [];

  async function visit(directory: string) {
    const children = await readdir(directory, { withFileTypes: true });
    for (const child of children) {
      const fullPath = path.join(directory, child.name);
      if (child.name.startsWith(".") || fullPath === JOURNAL || fullPath.startsWith(`${JOURNAL}${path.sep}`)) continue;
      if (child.isDirectory()) {
        entries.push({
          name: child.name,
          path: fullPath,
          relativePath: path.relative(VAULT, fullPath),
          directory: true,
        });
        await visit(fullPath);
      } else if (child.isFile() && child.name.endsWith(".md")) {
        entries.push({
          name: child.name.replace(/\.md$/, ""),
          path: fullPath,
          relativePath: path.relative(VAULT, fullPath),
          directory: false,
        });
      }
    }
  }

  await visit(VAULT);
  return entries.sort((a, b) => a.relativePath.localeCompare(b.relativePath));
}

async function exportSource(source: string) {
  const toast = await showToast({ style: Toast.Style.Animated, title: "Exportando…" });
  try {
    await execFileAsync(SCRIPT, [source, "Obsidian Importadas"]);
    toast.style = Toast.Style.Success;
    toast.title = "Exportación completada";
  } catch (error) {
    toast.style = Toast.Style.Failure;
    toast.title = "No se pudo exportar";
    toast.message = error instanceof Error ? error.message : String(error);
  }
}

export default function Command() {
  const entries = getEntries();

  return (
    <List isLoading={false} searchBarPlaceholder="Buscar una nota o carpeta…">
      <List.Item
        id="all"
        title="Todas las notas"
        subtitle="Exportar todas las notas Markdown fuera de journal"
        icon={Icon.ArrowRight}
        actions={<ActionPanel><Action title="Exportar todas" onAction={() => exportSource("all")} /></ActionPanel>}
      />
      <List.Section title="Notas y carpetas">
        {entries.then((items) => items.map((entry) => (
          <List.Item
            key={entry.path}
            id={entry.path}
            title={entry.name}
            subtitle={entry.relativePath}
            icon={entry.directory ? Icon.Folder : Icon.Document}
            keywords={[entry.relativePath]}
            actions={<ActionPanel><Action title={entry.directory ? "Exportar carpeta" : "Exportar nota"} onAction={() => exportSource(entry.relativePath)} /></ActionPanel>}
          />
        )))}
      </List.Section>
    </List>
  );
}
