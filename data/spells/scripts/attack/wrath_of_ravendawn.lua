local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, CONST_ME_BIGPLANTS)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_SMALLPLANTS)
combat:setArea(createCombatArea(AREA_CIRCLE3X3))

-- damage calc
function onGetFormulaValues(player, level, magicLevel)
	local min = (level / 5) + (magicLevel * 3) + 32
	local max = (level / 5) + (magicLevel * 9) + 40
	return -min, -max
end

function spellCallback(creature, position, count)
	if Creature(creature) then
		if count > 0 or math.random(0, 1) == 1 then
			position:sendMagicEffect(COMBAT_EARTHDAMAGE)
			-- doAreaCombat(cid, type, pos, area, min, max, effect)
			doAreaCombat(creature, CONST_ME_SMALLPLANTS, position, 0, -100, -100, CONST_ME_PLANTATTACK)
		end
		-- add events of random position of the spell
		if count < 3 then
			count = count + 1
			addEvent(spellCallback, math.random(500, 2000), creature, position, count)
		end
	end
end

function onTargetTile(creature, position)
	spellCallback(creature:getId(), position, 0)
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")
combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

function onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end