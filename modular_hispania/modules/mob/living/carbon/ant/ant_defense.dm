/mob/living/carbon/ant/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	..(AM, hitpush = FALSE)

/*Code for aliens attacking aliens. Because aliens act on a hivemind, I don't see them as very aggressive with each other.
As such, they can either help or harm other aliens. Help works like the human help command while harm is a simple nibble.
In all, this is a lot like the monkey code.
This code could certainly use with a touch of TLC, but it functions alright. Bit odd aliens attacking other aliens are like, full logged though
*/
/mob/living/carbon/ant/attack_alien(mob/living/carbon/alien/M)
	if(isturf(loc) && istype(loc.loc, /area/start))
		to_chat(M, "No attacking people at spawn, you jackass.")
		return
	switch(M.a_intent)
		if(INTENT_HELP)
			AdjustSleeping(-10 SECONDS)
			AdjustParalysis(-6 SECONDS)
			AdjustStunned(-6 SECONDS)
			AdjustWeakened(-6 SECONDS)
			AdjustKnockDown(-6 SECONDS)
			stand_up()
			visible_message("<span class='notice'>[M.name] nuzzles [src] trying to wake it up!</span>")

		if(INTENT_GRAB)
			grabbedby(M)

		else
			if(health > 0)
				M.do_attack_animation(src, ATTACK_EFFECT_BITE)
				playsound(loc, 'sound/weapons/bite.ogg', 50, 1, -1)
				visible_message("<span class='danger'>[M.name] bites [src]!</span>", \
						"<span class='userdanger'>[M.name] bites [src]!</span>")
				adjustBruteLoss(1)
				add_attack_logs(M, src, "Alien attack", ATKLOG_ALL)
			else
				to_chat(M, "<span class='warning'>[name] is too injured for that.</span>")

/mob/living/carbon/ant/attack_larva(mob/living/carbon/alien/larva/L)
	return attack_alien(L)

/mob/living/carbon/ant/attack_hand(mob/living/carbon/human/M)
	if(..())	//to allow surgery to return properly.
		return FALSE

	switch(M.a_intent)
		if(INTENT_HELP)
			if(M.on_fire)
				pat_out(M)
			else
				help_shake_act(M)
		if(INTENT_GRAB)
			grabbedby(M)
		if(INTENT_HARM)
			M.do_attack_animation(src, ATTACK_EFFECT_PUNCH)
		if(INTENT_DISARM)
			M.do_attack_animation(src, ATTACK_EFFECT_DISARM)
			return TRUE
	return FALSE

/mob/living/carbon/ant/attack_animal(mob/living/simple_animal/M)
	. = ..()
	if(.)
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		switch(M.melee_damage_type)
			if(BRUTE)
				adjustBruteLoss(damage)
			if(BURN)
				adjustFireLoss(damage)
			if(TOX)
				adjustToxLoss(damage)
			if(OXY)
				adjustOxyLoss(damage)
			if(CLONE)
				adjustCloneLoss(damage)
			if(STAMINA)
				adjustStaminaLoss(damage)

/mob/living/carbon/ant/acid_act(acidpwr, acid_volume)
	return FALSE //aliens are immune to acid.

/mob/living/carbon/ant/attack_slime(mob/living/simple_animal/slime/M) // This is very RNG based, maybe come back to this later - GDN
	if(..()) //successful slime attack
		var/damage = rand(5, 35)
		if(M.is_adult)
			damage = rand(10, 40)
		adjustBruteLoss(damage)
		add_attack_logs(M, src, "Slime'd for [damage] damage")
		updatehealth("slime attack")
