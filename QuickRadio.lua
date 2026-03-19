local QuickRadio = {}
QuickRadio.AddedGroups = {}

QuickRadio.RadioOptions = {
    [6] = {
        submenu = "索敌",
        content = {
            {
                optionName = "空袭警报",
                fileName = "sounds/voice_message_air_v1.wav",
                outputContent = "小心空中敌袭!"
            }
        }
    },

    [5] = {
        submenu = "申请",
        content = {
            {
                optionName = "请求指示空袭目标",
                fileName = "sounds/voice_message_target_for_airstrike_v1.wav",
                outputContent = "请求指示对地打击目标!"
            },
            {
                optionName = "请求航空侦察",
                fileName = "sounds/voice_message_air_recon_v1.wav",
                outputContent = "请求空中侦察!"
            },
        }
    },

    [4] = {
        submenu = "报告",
        content = {
            {
                optionName = "跟我来!",
                fileName = "sounds/voice_message_follow_me_0_1.wav",
                outputContent = "跟我来!"
            },
            {
                optionName = "掩护我!",
                fileName = "sounds/voice_message_cover_me_0_1.wav",
                outputContent = "掩护我!"
            },
            {
                optionName = "准备着陆!",
                fileName = "sounds/voice_message_landing_0_1.wav",
                outputContent = "准备着陆!"
            },
            {
                optionName = "正在返回基地!",
                fileName = "sounds/voice_message_return_to_base_0_1.wav",
                outputContent = "正在返回基地!"
            },
            {
                optionName = "装填中!",
                fileName = "sounds/voice_message_reloading_0_1.wav",
                outputContent = "正在装填!"
            },
            {
                optionName = "干得好!",
                fileName = "sounds/voice_message_well_done_0_1.wav",
                outputContent = "干得好!"
            },
        }
    },

    [3] = {
        submenu = "回答",
        content = {
            {
                optionName = "赞成!",
                fileName = "sounds/voice_message_yes_0_1.wav",
                outputContent = "同意!"
            },
            {
                optionName = "反对!",
                fileName = "sounds/voice_message_no_0_1.wav",
                outputContent = "不行!"
            },
            {
                optionName = "抱歉!",
                fileName = "sounds/voice_message_sorry_0_1.wav",
                outputContent = "对不起!"
            },
            {
                optionName = "谢谢你!",
                fileName = "vvoice_message_thank_you_0_1.wav",
                outputContent = "非常感谢!"
            },
        }
    },

    [1] = {
        submenu = "进攻!", 
        content = {
            {
                optionName = "进攻A点!",
                fileName = "sounds/voice_message_attack_A_0_1.wav",
                outputContent = "进攻A点!"
            },
            {
                optionName = "进攻B点!", 
                fileName = "sounds/voice_message_attack_B_0_1.wav",
                outputContent = "进攻B点!"
            },
            {
                optionName = "进攻C点!",
                fileName = "sounds/voice_message_attack_C_0_1.wav",
                outputContent = "进攻C点!"
            },
            {
                optionName = "进攻D点!", 
                fileName = "sounds/voice_message_attack_D_0_1.wav",
                outputContent = "进攻D点!"
            },
            {
                optionName = "攻击敌军基地!",
                fileName = "sounds/voice_message_attack_enemy_base_0_1.wav",
                outputContent = "攻击敌军基地!"
            },
            {
                optionName = "攻击敌军部队!", 
                fileName = "sounds/voice_message_attack_enemy_troops_0_1.wav",
                outputContent = "攻击敌军部队!"
            },
        }
    },

    [2] = {
        submenu = "防守!", 
        content = {
            {
                optionName = "防守A点!",
                fileName = "sounds/voice_message_defend_A_0_1.wav",
                outputContent = "防守A点!"
            },
            {
                optionName = "防守B点!",
                fileName = "sounds/voice_message_defend_B_0_1.wav",
                outputContent = "防守B点!"
            },
            {
                optionName = "防守C点!",
                fileName = "sounds/voice_message_defend_C_0_1.wav",
                outputContent = "防守A点!"
            },
            {
                optionName = "防守D点!",
                fileName = "sounds/voice_message_defend_D_0_1.wav",
                outputContent = "防守B点!"
            },
            {
                optionName = "防守基地!",
                fileName = "sounds/voice_message_cover_base_0_1.wav",
                outputContent = "防守基地!"
            },
        }
    },
}

function QuickRadio.ShowAndPlayRadio(parameters)
    local PlayerGroup = parameters[1]
    local fileName = parameters[2]
    local outputContent = parameters[3]
    local player = PlayerGroup:getUnit(1)
    if player then
        trigger.action.outTextForCoalition(player:getCoalition(), player:getPlayerName() .. ":" .. outputContent, 5)
        trigger.action.outSoundForCoalition(player:getCoalition(), fileName)
    end
end

function QuickRadio.AddRadioCommand(group)
    for i, entry in ipairs(QuickRadio.RadioOptions) do
        local submenu = missionCommands.addSubMenuForGroup(group:getID(), entry.submenu)
        for k, v in ipairs(entry.content) do
            local VtoPass = {group, v.fileName, v.outputContent}
            missionCommands.addCommandForGroup(group:getID(), v.optionName, submenu, QuickRadio.ShowAndPlayRadio, VtoPass)
        end
    end
end

QuickRadio.QuickRadioCallback = {}
function QuickRadio.QuickRadioCallback:onEvent(Event)
    if Event.id == 15 then
        local group = Event.initiator:getGroup()
        if group then
            local alreadyAdded = false
            
            -- 检查这个组是否已经添加过无线电
            for i, addedGroup in ipairs(QuickRadio.AddedGroups) do
                if addedGroup == group then
                    alreadyAdded = true
                    break
                end
            end
            
            -- 如果没有添加过，则添加
            if not alreadyAdded then
                QuickRadio.AddRadioCommand(group)
                table.insert(QuickRadio.AddedGroups, group)
            end
        end
    end
end
trigger.action.outText("无线电脚本已加载",5)
world.addEventHandler(QuickRadio.QuickRadioCallback)