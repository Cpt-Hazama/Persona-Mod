PERSONA = PERSONA or {}
PERSONA_DANCERS = PERSONA_DANCERS or {}
PERSONA_ITEMS = {}

local string_find = string.find

function P_AddItem(name,class,category)
	if !PERSONA_ITEMS[class] then
		PERSONA_ITEMS[class] = {
			Name = name,
			Class = class,
			Category = category or "Misc."
		}
		list.Set("PERSONA_DATA_ITEMS", class, PERSONA_ITEMS[class])
	end
end

P_AddItem("Recov-R: 100mg","item_persona_hp","Battle Items")
P_AddItem("Medicine","item_persona_hp_small","Battle Items")
P_AddItem("Chewing Soul","item_persona_sp","Battle Items")
P_AddItem("Snuff Soul","item_persona_sp_small","Battle Items")
P_AddItem("Velvet Key","item_persona_velvetkey","Key Items")

function P_AddDancer(name,class,category)
	if !PERSONA_DANCERS[class] then
		PERSONA_DANCERS[class] = {
			Name = name,
			Category = category,
			Class = class
		}
		list.Set("PERSONA_DATA_DANCERS", class, PERSONA_DANCERS[class])
	end
end

P_AddDancer("Tohru Adachi","sent_dance_adachi","Persona 4")
P_AddDancer("Goro Akechi","sent_dance_akechi","Persona 5")
P_AddDancer("Futaba Sakura","sent_dance_futaba","Persona 5")
P_AddDancer("Fuuka Yamagishi","sent_dance_fuuka","Persona 3")
P_AddDancer("Marie","sent_dance_marie","Persona 4")
P_AddDancer("Naoto Shirogane","sent_dance_naoto","Persona 4")
P_AddDancer("Yu Narukami","sent_dance_yu","Persona 4")
P_AddDancer("Yukari Takeba","sent_dance_yukari","Persona 3")

function P_AddPersona(name,class,model,aura,category,menuOptions)
	if !PERSONA[class] then
		PERSONA[class] = {
			Name = name,
			Model = model,
			Aura = aura,
			Category = category or (string_find(model, "persona5") && "Persona 5" or string_find(model, "persona4") && "Persona 4" or "Persona 3"),
			Class = "sent_persona_" .. class,
			MenuOptions = menuOptions or {}
		}
		list.Set("PERSONA_DATA_PERSONAS", "sent_persona_" .. class, PERSONA[class])
	end
end

P_AddPersona(
	"Izanagi",
	"izanagi",
	"models/cpthazama/persona5/persona/izanagi.mdl",
	"persona_aura_blue"
)

P_AddPersona(
	"Izanagi Picaro",
	"izanagi_picaro",
	"models/cpthazama/persona5/persona/izanagi.mdl",
	"persona_aura_blue",
	nil,
	{
		Skin = 1
	}
)

P_AddPersona(
	"Izanagi (Velvet)",
	"izanagi_velvet",
	"models/cpthazama/persona5/persona/izanagi_velvet.mdl",
	"persona_aura_velvet"
)

P_AddPersona(
	"Magatsu-Izanagi",
	"magatsu_izanagi",
	"models/cpthazama/persona5/persona/magatsu_izanagi.mdl",
	"persona_aura_red",
	nil,
	{
		Anim_Attack = "ghostly_wail_noXY"
	}
)

P_AddPersona(
	"Magatsu-Izanagi Picaro",
	"magatsu_izanagi_picaro",
	"models/cpthazama/persona5/persona/magatsu_izanagi_picaro.mdl",
	"persona_aura_blue",
	nil,
	{
		Skin = 1,
		Anim_Attack = "ghostly_wail_noXY"
	}
)

P_AddPersona(
	"Magatsu-Izanagi (Classic)",
	"magatsu_izanagi_p4",
	"models/cpthazama/persona5/persona/magatsu_izanagi.mdl",
	"persona_aura_red",
	nil,
	{
		Skin = 1,
		Anim_Attack = "ghostly_wail_noXY"
	}
)

P_AddPersona(
	"Magatsu-Izanagi (Velvet)",
	"magatsu_izanagi_velvet",
	"models/cpthazama/persona5/persona/magatsu_izanagi_velvet.mdl",
	"persona_aura_velvet",
	nil,
	{
		Anim_Attack = "ghostly_wail_noXY"
	}
)

P_AddPersona(
	"Magatsu-Izanagi-no-Okami",
	"magatsu_izanagi_okami",
	"models/cpthazama/persona5/persona/magatsu_izanagi_no_okami.mdl",
	"persona_aura_red"
)

P_AddPersona(
	"Izanagi-no-Okami",
	"izanagi_okami",
	"models/cpthazama/persona5/persona/izanagi_no_okami.mdl",
	"persona_aura_yellow"
)

P_AddPersona(
	"Thanatos",
	"thanatos",
	"models/cpthazama/persona5/persona/thanatos.mdl",
	"persona_aura_blue"
)

P_AddPersona(
	"Tsukiyomi",
	"tsukiyomi",
	"models/cpthazama/persona5/persona/tsukiyomi.mdl",
	"persona_aura_red"
)

P_AddPersona(
	"Satanael",
	"satanael",
	"models/cpthazama/persona5/persona/satanael.mdl",
	"persona_aura_blue"
)

P_AddPersona(
	"Satanael (Small)",
	"satanael_small",
	"models/cpthazama/persona5/persona/satanael.mdl",
	"persona_aura_blue"
)

P_AddPersona(
	"Loki",
	"loki",
	"models/cpthazama/persona5/persona/loki.mdl",
	"persona_aura_red"
)

P_AddPersona(
	"Alice",
	"alice",
	"models/cpthazama/persona5/persona/alice.mdl",
	"persona_aura_purple"
)

P_AddPersona(
	"Ariadne",
	"ariadne",
	"models/cpthazama/persona5/persona/ariadne.mdl",
	"persona_aura_blue"
)

P_AddPersona(
	"Ariadne Picaro",
	"ariadne_picaro",
	"models/cpthazama/persona5/persona/ariadne_picaro.mdl",
	"persona_aura_blue"
)

P_AddPersona(
	"Yoshitsune",
	"yoshitsune",
	"models/cpthazama/persona5/persona/yoshitsune.mdl",
	"persona_aura_blue"
)

P_AddPersona(
	"Hypnos",
	"hypnos",
	"models/cpthazama/persona3/persona/hypnos.mdl",
	"persona_aura_red"
)

P_AddPersona(
	"Medea",
	"medea",
	"models/cpthazama/persona3/persona/medea.mdl",
	"persona_aura_red"
)

P_AddPersona(
	"Azathoth",
	"azathoth",
	"models/cpthazama/persona5/persona/azathoth.mdl",
	"persona_aura_red"
)

P_AddPersona(
	"Orpheus",
	"orpheus",
	"models/cpthazama/persona3/persona/orpheus.mdl",
	"persona_aura_blue"
)

P_AddPersona(
	"Messiah",
	"messiah",
	"models/cpthazama/persona3/persona/messiah.mdl",
	"persona_aura_blue"
)

P_AddPersona(
	"Robin-Hood",
	"robinhood",
	"models/cpthazama/persona5/persona/robinhood.mdl",
	"persona_aura_blue"
)

P_AddPersona(
	"Arsene",
	"arsene",
	"models/cpthazama/persona5/persona/arsene.mdl",
	"persona_aura_blue"
)

P_AddPersona(
	"Asterius",
	"asterius",
	"models/cpthazama/persona4/persona/asterius.mdl",
	"persona_aura_red"
)

P_AddPersona(
	"Carmen",
	"carmen",
	"models/cpthazama/persona5/persona/carmen.mdl",
	"persona_aura_blue"
)

P_AddPersona(
	"Tomoe",
	"tomoe",
	"models/cpthazama/persona4/persona/tomoe.mdl",
	"persona_aura_blue"
)

P_AddPersona(
	"Konohana Sakuya",
	"sakuya",
	"models/cpthazama/persona4/persona/sakuya.mdl",
	"persona_aura_blue"
)

P_AddPersona(
	"Necronomicon",
	"necronomicon",
	"models/cpthazama/persona5/persona/necronomicon.mdl",
	"persona_aura_blue"
)

P_AddPersona(
	"Jack-o-Lantern",
	"jack",
	"models/cpthazama/persona5/persona/jack-o-lantern.mdl",
	"persona_aura_red"
)

P_AddPersona(
	"Loki (Shadow)",
	"loki_shadow",
	"models/cpthazama/persona5/persona/loki.mdl",
	"persona_aura_red",
	nil,
	{
		Custom = function(self)
			self:SetSubMaterial(0,"models/cpthazama/persona5/loki/loki_shadow")
		end
	}
)

P_AddPersona(
	"Pandora",
	"pandora",
	"models/cpthazama/persona5_strikers/persona/pandora.mdl",
	"persona_aura_blue"
)

local ENT = FindMetaTable("Entity")

function ENT:PlayInstaKillTheme(ents,t,ft)
	local function song(v,t,ft)
		if v.InstaKillTheme then v.InstaKillTheme:Stop() end
		v.InstaKillTheme = CreateSound(v,"cpthazama/persona5/instakill.wav")
		v.InstaKillTheme:SetSoundLevel(0)
		v.InstaKillTheme:Play()
		v.InstaKillTheme:ChangeVolume(1)
		v.InstaKillThemeID = v.InstaKillThemeID && v.InstaKillThemeID +1 or 1
		local id = v.InstaKillThemeID
		timer.Simple(t,function()
			if v.InstaKillTheme && v.InstaKillTheme:IsPlaying() && v.InstaKillThemeID == id then
				v.InstaKillTheme:FadeOut(ft)
			end
		end)
	end

	for _,v in pairs(ents) do
		if IsValid(v) && v:IsPlayer() then
			song(v,t,ft)
		end
	end
end