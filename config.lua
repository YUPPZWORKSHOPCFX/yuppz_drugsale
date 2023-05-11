--===== FiveM Script =========================================
--= drugsale - YUPPZWORKSHOP CFX (Webhook)
--===== Developed By: ========================================
--= YUPPZWORKSHOP CFX
--= Copyright (C) YUPPZWORKSHOP CFX - All Rights Reserved
--= You are not allowed to sell this script or edit
--============================================================ 


Config = {}
Config.PoliceCount = 0 
Config.SellDelay = 1000 --@=> เวลาในการขายยา
Config.FreezeTime = 1000 --@=> โดนช็อต
Config.CancelDelay = 1000 --@=> ยกเลิกขายยาจะขายได้อีกกี่นาที
Config.FreezeText = "คุณกำลังโดนช็อต" -- @=> ข้อความพลาด
Config.Text = "กำลังขายยา..." -- @=> ข้อความชนะ
Config.ItemInHand = "prop_ld_case_01" --@=> ไอเท็มมือในมือ
Config.Blips = {
    Radius = 100.0, --@=> ขนาดของวงในแมพตอนเริ่มขาย
    Color = 1, --@=> สีในแมพ
    Alpha = 100, --@=> ความโปร่งใส่ของจุดในแมพ
    Text = '<font face="font4thai">ขายยา</font>' --ชื่อblip
}

STOPSELL = function ()
	exports["?"]:ShowHelpNotification("~w~Press ~g~[X]~w~ ยกเลิกขายยา") -- @=>TextUI
end

STARTSELL = function ()
	exports["?"]:ShowHelpNotification("~w~Press ~g~[X]~w~ ยกเลิกขายยา") -- @=>TextUI
end




Config["Discord"] = {
    Webhook = '',--webhook
    Enable = false, -- @=> เปิดใช้ Discord Log แยก
    DiscordLog = function(playerId,text) -- @=> Log แยก
        TriggerEvent('azael_discordlogs:sendToDiscord', '?', sendToDiscord, xPlayer.source, '^2')--@=> azaellog
    end
}

Config.DrugsList = { --@=> ใส่ไอเท็มที่จะให้กดใช้
    {
        Name = "coke_pooch", --@=> ชื่อยา
        Price = {150,300} --@=> เงินแดงที่จะได้
    }
--    {
--        Name = "?", --@=> ชื่อยา
--        Price = {0,0} --@=> เงินแดงที่จะได้
--    }, --@=> เติมไว้เมื่อใช้งานบรรทัดต่อไป
}

Config.Animations = {
    Win = { --@=> Animation ตอนชนะ
        dict = "anim@arena@celeb@flat@solo@no_props@",
        name = "flip_a_player_a"--@=> ชนะ
    },
    Loss = { --@=> Animation ตอนแพ้
        dict = "anim@heists@ornate_bank@chat_manager",
        name = "fail"--@=> แพ้
    }
}

Config.NPCSpawnPoint = { --@=> จุดสุ่มเดินของ NPC
    {
        Model = "a_m_m_beach_01", --@=> npc moedel
        Pos = vector3(247.39, -1719.44, 29.08), --@=> x y z
        Heading = 45.0 --@=> หันหน้า
    }
--    {
--       Model = "?",
--       Pos = vector3(-0, -0, -0),
--        Heading = 0
--    }, --เติมไว้เมื่อใช้งานบรรทัดต่อไป
}
