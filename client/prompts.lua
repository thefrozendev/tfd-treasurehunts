local prompts = {
    ["vendor"] = {
        prompt = 0,
        group = GetRandomIntInRange(0, 0xFFFFFF),
        label = "Open Vendor",
    },
    ["dig"] = {
        prompt = 0,
        group = GetRandomIntInRange(0, 0xFFFFFF),
        label = "Dig Here",
    },
}

function SetupPrompts()
    for _, v in pairs(prompts) do
        v.prompt = UiPromptRegisterBegin()
        UiPromptSetControlAction(v.prompt, 0xDFF812F9) -- INPUT_CONTEXT
        UiPromptSetText(v.prompt, VarString(10, "LITERAL_STRING", v.label))
        UiPromptSetEnabled(v.prompt, true)
        UiPromptSetVisible(v.prompt, true)
        UiPromptSetStandardMode(v.prompt, 1) -- STANDARD_MODE_PRESSED
        UiPromptSetGroup(v.prompt, v.group)
        UiPromptRegisterEnd(v.prompt)
    end
end

function ShowPrompt(group, action)
    local prompt = prompts[group]
    if prompt and prompt[action] then
        local label = VarString(10, "LITERAL_STRING", prompt.label)
        UiPromptSetActiveGroupThisFrame(prompt.group, label, 0, 0, 0, 0)

        if UiPromptHasStandardModeCompleted(prompt.prompt) then
            Wait(100)
            return action
        end
    end
end
