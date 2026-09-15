return {
  {
    "itchyny/calendar.vim",
    cmd = { "Calendar" },
    keys = {
      { "<leader>oc", "<cmd>Calendar<cr>", desc = "Calendario de notas diarias" },
    },
    init = function()
      local function open_daily_note(year, month, day)
        local date = string.format("%04d-%02d-%02d", year, month, day)
        local journal_dir = "/Volumes/Files/notes/journal"
        local note_path = journal_dir .. "/" .. date .. ".md"

        -- Si hay ventanas abiertas que no sean de calendario, abrir en una de ellas
        local target_win = nil
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype ~= "calendar" then
            target_win = win
            break
          end
        end

        if target_win then
          vim.api.nvim_set_current_win(target_win)
        end

        vim.cmd("edit " .. vim.fn.fnameescape(note_path))

        -- Si el archivo acaba de ser creado (está vacío), poblar con plantilla
        local bufnr = vim.api.nvim_get_current_buf()
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        if #lines <= 1 and (lines[1] == nil or lines[1] == "") then
          local template_path = "/Volumes/Files/notes/templates/plantilla-diaria.md"
          if vim.fn.filereadable(template_path) == 1 then
            local template_lines = vim.fn.readfile(template_path)
            for i, line in ipairs(template_lines) do
              template_lines[i] = line:gsub("{{date}}", date):gsub("{{title}}", date):gsub("{{id}}", date)
            end
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, template_lines)
          end
        end
      end

      _G.obsidian_calendar_open_daily = open_daily_note

      -- Autocmd para asignar <CR>, o y doble clic en el buffer de calendar.vim
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "calendar",
        callback = function(args)
          local function trigger_action()
            local ok, ymd = pcall(vim.fn.eval, "b:calendar.day().get_ymd()")
            if ok and type(ymd) == "table" and #ymd >= 3 then
              open_daily_note(ymd[1], ymd[2], ymd[3])
            end
          end

          vim.keymap.set("n", "<CR>", trigger_action,
            { buffer = args.buf, silent = true, noremap = true, desc = "Abrir/Crear nota diaria" })
          vim.keymap.set("n", "<2-LeftMouse>", trigger_action,
            { buffer = args.buf, silent = true, noremap = true, desc = "Abrir/Crear nota diaria" })
          vim.keymap.set("n", "o", trigger_action,
            { buffer = args.buf, silent = true, noremap = true, desc = "Abrir/Crear nota diaria" })
        end,
      })

      vim.g.calendar_google_calendar = 0
      vim.g.calendar_google_task = 0
    end,
  },
}
