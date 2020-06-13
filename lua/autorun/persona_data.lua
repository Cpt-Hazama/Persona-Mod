PERSONA = {}

PERSONA["izanagi"] = {}
PERSONA["izanagi"].Model = "models/cpthazama/persona5/persona/izanagi.mdl"
PERSONA["izanagi"].Aura = "jojo_aura_blue"
PERSONA["izanagi"].Name = "Izanagi"

PERSONA["izanagi_picaro"] = {}
PERSONA["izanagi_picaro"].Model = "models/cpthazama/persona5/persona/izanagi.mdl"
PERSONA["izanagi_picaro"].Aura = "jojo_aura_red"
PERSONA["izanagi_picaro"].Name = "Izanagi Picaro"

PERSONA["magatsu_izanagi"] = {}
PERSONA["magatsu_izanagi"].Model = "models/cpthazama/persona5/persona/magatsu_izanagi.mdl"
PERSONA["magatsu_izanagi"].Aura = "jojo_aura_red"
PERSONA["magatsu_izanagi"].Name = "Magatsu-Izanagi"

PERSONA["izanagi_okami"] = {}
PERSONA["izanagi_okami"].Model = "models/cpthazama/persona5/persona/izanagi_no_okami.mdl"
PERSONA["izanagi_okami"].Aura = "jojo_aura_gold"
PERSONA["izanagi_okami"].Name = "Izanagi-no-Okami"

game.AddParticles("particles/magatsu_izanagi.pcf")
local pParticleList = {
	"fo4_libertyprime_impact",
	"fo4_libertyprime_laser"
}
for _,v in ipairs(pParticleList) do PrecacheParticleSystem(v) end

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