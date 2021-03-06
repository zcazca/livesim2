-- Beatmap information UI (download)
-- Part of Live Simulator: 2
-- See copyright notice in main.lua

local AquaShine = ...
local love = love
local BeatmapInfoDL = AquaShine.Node:extend("Livesim2.BeatmapInfoDL")
local TextShadow = AquaShine.LoadModule("uielement.text_with_shadow")
local SimpleButton = AquaShine.LoadModule("uielement.simple_button")
local CoverArtLoading = AquaShine.LoadModule("uielement.cover_art_loading")
local Checkbox = AquaShine.LoadModule("uielement.checkbox")

function BeatmapInfoDL.init(this, track_data, NoteLoader)
	AquaShine.Node.init(this)
	this.infofont = AquaShine.LoadFont("MTLmr3m.ttf", 22)
	this.arrangementfont = AquaShine.LoadFont("MTLmr3m.ttf", 16)
	this.layoutimage = AquaShine.LoadImage("assets/image/ui/com_win_40.png")
	this.status = ""
	
	-- Title text
	this.child[1] = TextShadow(AquaShine.LoadFont("MTLmr3m.ttf", 30), "", 64, 560)
		:setShadow(1, 1, true)
	-- OK button
	this.child[2] = SimpleButton(
		AquaShine.LoadImage("assets/image/ui/com_button_14.png"),
		AquaShine.LoadImage("assets/image/ui/com_button_14se.png"),
		function()
			this.okButtonCallback()
		end
	)
		:setPosition(768, 529)
		:setDisabledImage(AquaShine.LoadImage("assets/image/ui/com_button_14di.png"))
		:disable()
	this.child[3] = CoverArtLoading()
		:setPosition(440, 130)
	-- Autoplay checkbox
	this.child[4] = Checkbox("Autoplay", 440, 520, function(checked)
			AquaShine.SaveConfig("AUTOPLAY", checked and "1" or "0")
		end)
		:setColor(0, 0, 0)
		:setChecked(AquaShine.LoadConfig("AUTOPLAY", 0) == 1)
	-- Random checkbox
	this.child[5] = Checkbox("Random", 440, 556)
		:setColor(0, 0, 0)
	this.trackdata = track_data
	this.beatmap_name = track_data.name
end

function BeatmapInfoDL.setBeatmapIndex(this, index)
	-- index is difficulty name
	this.beatmapidx = index
	local ci = this.trackdata.live[index].combo
	local si = this.trackdata.live[index].score
	
	this.score_info = string.format("%d\n%d\n%d\n%d", si[4], si[3], si[2], si[1])
	this.combo_info = string.format("%d\n%d\n%d\n%d", ci[4], ci[3], ci[2], ci[1])
	this.difficulty = string.format("%d\226\152\134", this.trackdata.live[index].star)
end

function BeatmapInfoDL.draw(this)
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(this.layoutimage, 420, 110, 0, 0.85, 0.85)
	love.graphics.rectangle("fill", 440, 130, 160, 160)
	love.graphics.setColor(0, 0, 0)
	love.graphics.setFont(this.infofont)
	love.graphics.print(this.beatmap_name, 423, 85)
	love.graphics.print(this.status, 440, 480)
	love.graphics.print("Score", 620, 132)
	love.graphics.print("Combo", 800, 132)
	love.graphics.print("S\nA\nB\nC", 604, 152)
	love.graphics.print("Difficulty:", 440, 380)
	
	if this.beatmapidx then
		local name = this.trackdata.name
		local si = this.score_info or "-\n-\n-\n-"
		local ci = this.combo_info or "-\n-\n-\n-"
		local din = this.difficulty or "Unknown"
		
		love.graphics.print(si, 620, 152)
		love.graphics.print(ci, 800, 152)
		love.graphics.print(din, 600, 380)
	end
	
	love.graphics.setColor(1, 1, 1)
	love.graphics.print(this.beatmap_name, 422, 84)
	return AquaShine.Node.draw(this)
end

function BeatmapInfoDL.setLiveIconImage(this, img)
	return this.child[3]:setImage(img)
end

function BeatmapInfoDL.setStatus(this, text)
	this.status = assert(type(text) == "string" and text, "bad argument #1 to 'setStatus' (string expected)")
end

function BeatmapInfoDL.setOKButtonCallback(this, cb)
	this.okButtonCallback = cb
	
	if not(cb) then
		this.child[2]:disable()
	else
		this.child[2]:enable()
	end
end

function BeatmapInfoDL.isRandomTicked(this)
	return this.child[5]:isChecked()
end

return BeatmapInfoDL
