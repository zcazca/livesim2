-- Added score, update routine using the new EffectPlayer
-- Part of Live Simulator: 2
-- See copyright notice in main.lua

local tween = require("tween")
local DEPLS = ...
local ScoreNode = {}

local _common_meta = {__index = ScoreNode}
local graphics = love.graphics

function ScoreNode.Create(score)
	local out = {}
	local Images = DEPLS.Images
	
	out.score_info = {opacity = 1, scale = 1.125, x = 520}
	out.main_tween = tween.new(100, out.score_info, {x = 570, scale = 1})
	out.opacity_tween = tween.new(200, out.score_info, {opacity = 0})
	out.elapsed_time = 0
	out.elements = {}
	out.elements[#out.elements + 1] = Images.ScoreNode.Plus
	
	do
		local i = 1
		for w in tostring(score):gmatch("%d") do
			graphics.draw(Images.ScoreNode[tonumber(w)], i * 24, 0)
			i = i + 1
			out.elements[i] = Images.ScoreNode[tonumber(w)]
		end
	end
	
	return (setmetatable(out, _common_meta))
end

function ScoreNode.Update(this, deltaT)
	this.elapsed_time = this.elapsed_time + deltaT
	this.main_tween:update(deltaT)
	
	if this.elapsed_time >= 200 then
		this.opacity_tween:update(deltaT)
	end
	
	return this.elapsed_time >= 450
end

function ScoreNode.Draw(this)
	graphics.setColor(1, 1, 1, this.score_info.opacity * DEPLS.LiveOpacity)
	for i = 1, #this.elements do
		local j = i - 1
		graphics.draw(this.elements[i], this.score_info.x + j * 24 * this.score_info.scale, 72, 0, this.score_info.scale, this.score_info.scale, 0, 16)
	end
	graphics.setColor(1, 1, 1)
end

return ScoreNode
