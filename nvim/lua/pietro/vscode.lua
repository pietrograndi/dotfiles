local function split(direction, file)
    vim.fn.VSCodeCall(direction == 'h' and 'workbench.action.splitEditorDown' or 'workbench.action.splitEditorRight')
    if file ~= '' then
        vim.fn.VSCodeExtensionNotify('open-file', vim.fn.expand(file), 'all')
    end
end

local function splitNew(direction, file)
    split(direction, file == '' and '__vscode_new__' or file)
end

local function closeOtherEditors()
    vim.fn.VSCodeNotify('workbench.action.closeEditorsInOtherGroups')
    vim.fn.VSCodeNotify('workbench.action.closeOtherEditors')
end

local function manageEditorSize(count, to)
    local count = count or 1
    for _ = 1, count do
        vim.fn.VSCodeNotify(to == 'increase' and 'workbench.action.increaseViewSize' or 'workbench.action.decreaseViewSize')
    end
end

local function vscodeCommentary(...)
    local args = {...}
    if #args == 0 then
        vim.o.operatorfunc = 'vscodeCommentary'
        return 'g@'
    elseif #args > 1 then
        line1, line2 = args[1], args[2]
    else
        line1, line2 = vim.fn.line("'["), vim.fn.line("']")
    end

    vim.fn.VSCodeCallRange("editor.action.commentLine", line1, line2, 0)
end

local function openVSCodeCommandsInVisualMode()
    vim.cmd('normal! gv')
    local visualmode = vim.fn.visualmode()
    if visualmode == 'V' then
        local startLine = vim.fn.line('v')
        local endLine = vim.fn.line('.')
        vim.fn.VSCodeNotifyRange("workbench.action.showCommands", startLine, endLine, 1)
    else
        local startPos = vim.fn.getpos("v")
        local endPos = vim.fn.getpos(".")
        vim.fn.VSCodeNotifyRangePos(
            "workbench.action.showCommands",
            startPos[1],
            endPos[1],
            startPos[2],
            endPos[2],
            1
        )
    end
end

local function openWhichKeyInVisualMode()
    vim.cmd('normal! gv')
    local visualmode = vim.fn.visualmode()
    if visualmode == 'V' then
        local startLine = vim.fn.line('v')
        local endLine = vim.fn.line('.')
        vim.fn.VSCodeNotifyRange("whichkey.show", startLine, endLine, 1)
    else
        local startPos = vim.fn.getpos("v")
        local endPos = vim.fn.getpos(".")
        vim.fn.VSCodeNotifyRangePos(
            "whichkey.show",
            startPos[1],
            endPos[1],
            startPos[2],
            endPos[2],
            1
        )
    end
end

-- Definizione di comandi
vim.api.nvim_create_user_command('Split', function(opts)
    split('h', opts.args)
end, { nargs = '?' })

vim.api.nvim_create_user_command('Vsplit', function(opts)
    split('v', opts.args)
end, { nargs = '?' })

vim.api.nvim_create_user_command('New', function(opts)
    splitNew('h', '__vscode_new__')
end, { nargs = '?' })

vim.api.nvim_create_user_command('Vnew', function(opts)
    splitNew('v', '__vscode_new__')
end, { nargs = '?' })

vim.api.nvim_create_user_command('Only', function(opts)
    if opts.bang then
        closeOtherEditors()
    else
        vim.fn.VSCodeNotify('workbench.action.joinAllGroups')
    end
end, { bang = true })

-- Mappature
vim.keymap.set('n', '<C-j>', function()
    vim.fn.VSCodeNotify('workbench.action.navigateDown')
end, { silent = true })

vim.keymap.set('x', '<C-j>', function()
    vim.fn.VSCodeNotify('workbench.action.navigateDown')
end, { silent = true })

vim.keymap.set('n', '<C-k>', function()
    vim.fn.VSCodeNotify('workbench.action.navigateUp')
end, { silent = true })

vim.keymap.set('x', '<C-k>', function()
    vim.fn.VSCodeNotify('workbench.action.navigateUp')
end, { silent = true })

vim.keymap.set('n', '<C-h>', function()
    vim.fn.VSCodeNotify('workbench.action.navigateLeft')
end, { silent = true })

vim.keymap.set('x', '<C-h>', function()
    vim.fn.VSCodeNotify('workbench.action.navigateLeft')
end, { silent = true })

vim.keymap.set('n', '<C-l>', function()
    vim.fn.VSCodeNotify('workbench.action.navigateRight')
end, { silent = true })

vim.keymap.set('x', '<C-l>', function()
    vim.fn.VSCodeNotify('workbench.action.navigateRight')
end, { silent = true })

vim.keymap.set('n', 'gr', function()
    vim.fn.VSCodeNotify('editor.action.goToReferences')
end, { silent = true })

vim.keymap.set('x', '<C-/>', function()
    return vscodeCommentary()
end, { expr = true })

vim.keymap.set('n', '<C-/>', function()
    return vscodeCommentary() .. '_'
end, { expr = true })

vim.keymap.set('n', '<C-w>_', function()
    vim.fn.VSCodeNotify('workbench.action.toggleEditorWidths')
end, { silent = true })

vim.keymap.set('n', '<Space>', function()
    vim.fn.VSCodeNotify('whichkey.show')
end, { silent = true })

vim.keymap.set('x', '<Space>', function()
    openWhichKeyInVisualMode()
end, { silent = true })

vim.keymap.set('x', '<C-P>', function()
    openVSCodeCommandsInVisualMode()
end, { silent = true })

vim.keymap.set('n', '<Tab>', function()
    vim.cmd("Tabnext")
end)

vim.keymap.set('n', '<S-Tab>', function()
    vim.cmd("Tabprev")
end)

vim.keymap.set('x', 'gc', "<Plug>VSCodeCommentary", { remap = true })
vim.keymap.set('n', 'gc', "<Plug>VSCodeCommentary", { remap = true })
vim.keymap.set('o', 'gc', "<Plug>VSCodeCommentary", { remap = true })
vim.keymap.set('n', 'gcc', "<Plug>VSCodeCommentaryLine", { remap = true })
