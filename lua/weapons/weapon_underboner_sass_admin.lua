AddCSLuaFile()

SWEP.Base 					= "weapon_base"
SWEP.PrintName				= "True Badtime"
SWEP.HoldType 				= "normal"
SWEP.Slot					= 0
SWEP.SlotPos				= 0
SWEP.Spawnable				= true
SWEP.AdminOnly				= false
SWEP.Primary.ClipSize 		= 0
SWEP.Primary.DefaultClip 	= 0
SWEP.DrawCrosshair			= true
SWEP.Category 				= "Undertale"
SWEP.DrawWeaponInfoBox		= true
SWEP.BounceWeaponIcon		= false
SWEP.ViewModel 				= "models/weapons/c_fuckallofyou.mdl"
SWEP.WorldModel 			= ""
SWEP.Primary.Automatic 		= true
SWEP.Secondary.Automatic 	= true
//SWEP.ShowViewModel 			= true
//SWEP.ShowWorldModel 		= false
SWEP.Primary.Ammo 			= ""
SWEP.Secondary.Ammo 		= ""

function TraceHull( vecstart, vecend, vecmin, vecmax, tracefiler )
	local trace = util.TraceHull( {
		start = vecstart,
		endpos = vecend,
		filter = tracefiler,
		mins = vecmin,
		maxs = vecmax,
		mask = MASK_SHOT_HULL
	} )
	
	return trace
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	
	if( SERVER ) then
		util.AddNetworkString( "miss" )
		
		hook.Add( "EntityTakeDamage", "DamageAdmin", function( ent, dmginfo )
			if( ent:IsPlayer() && ent:Health() > 0 ) then
				if( ent:GetActiveWeapon():IsValid() && ent:GetVar( "miss", NULL ) != NULL ) then
					if( CurTime() >= ent:GetVar( "miss", NULL ) ) then
						if( ent:GetActiveWeapon():GetClass() == "weapon_underboner_sass_admin" ) then
							net.Start( "miss" )
								net.WriteEntity( ent )
								local dmgpos = dmginfo:GetDamagePosition()
								if( dmgpos != Vector() ) then
									net.WriteVector( dmgpos )
								else
									net.WriteVector( ent:EyePos() )
								end
							net.Broadcast()
							
							ent:SetVar( "miss", CurTime() + 0.5 )
							
							dmginfo:SetDamage( 0 )
							dmginfo:SetDamageForce( Vector( 0, 0, 0 ) )
							dmginfo:SetDamageType( 0 )
							dmginfo:SetDamageBonus( 0 )

							ent:EmitSound( Sound( "undertale/attack.wav" ), 75, 100, 1, CHAN_AUTO  )
						end
					end
				end
			end
		end )
	end
	
	if( CLIENT ) then		
		net.Receive( "miss", function()
			local ply = net.ReadEntity()
			local vec = net.ReadVector()
			//print( ply, vec )
			
			local emitter = ParticleEmitter( vec, false )
			
			local particle = emitter:Add( Material( "undertale/miss" ), vec )
			if( particle ) then
				particle:SetVelocity( Vector( 0, 0, 10 ) )
				particle:SetColor( 255, 255, 255 ) 
				particle:SetLifeTime( 0 )
				particle:SetDieTime( 2 )
				particle:SetStartSize( 10 )
				particle:SetEndSize( 10 )
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 0 )
				particle:SetGravity( Vector( 0, 0, 0 ) )
			end
			
			emitter:Finish()
		end )
	end
end

function SWEP:Equip()
	self:SetVar( "grabbedEnt", nil )
	self:SetVar( "distance", 0 )
	self:SetVar( "blockBoneGround", 0 )
	self:SetVar( "invincible", 0 )
	self:SetVar( "btm_client", NULL )
	self:SetVar( "anim_reset", NULL )
	
	self.Owner:SetVar( "miss", 0 )
	self.Owner:SetVar( "player_model", self.Owner:GetModel() )
end

if( CLIENT ) then killicon.Add( "weapon_undertale_sans_admin", "undertale/killicon_telekinesis", color_white ) end

function SWEP:Deploy( )
	if( CLIENT ) then return true end
	
	if( self.BeatSound ) then
		self.BeatSound:ChangeVolume( 1, 0.1 )
	else
		self.BeatSound = CreateSound( self.Owner, Sound( "MOGOVOLONIO.mp3" ) )
		self.BeatSound:Play()
	end
	
	local model	= "models/player/kleiner.mdl"
	if( util.IsValidModel( model ) ) then
		self.Owner:SetModel( model )
	end

	local model	= "models/player/kleiner.mdl"
	if( util.IsValidModel( model ) ) then
		self.Owner:SetModel( model )
	end

	return true
end

function SWEP:KillSounds()
	if ( self.BeatSound ) then self.BeatSound:Stop() self.BeatSound = nil end
end

function SWEP:OnDrop( )
	if(self.Owner:GetModel() == "models/player/kleiner.mdl") then
		self.Owner:SetBodygroup( 1, 0 )
		self.Owner:SetBodygroup( 2, 0 )
	end

	if(self.Owner:GetModel() == "models/player/kleiner.mdl") then
		self.Owner:SetBodygroup( 2, 0 )
	end


	if( self.Owner:IsValid() ) then
		if( self.Owner:Health() ) > 0 then
			self.Owner:SetModel( self.Owner:GetVar( "player_model", NULL ) )
		end
	end

	self:KillSounds()
end

function SWEP:OnRemove()
	if( CLIENT ) then return end
	if( self.Owner:IsValid() ) then
		if( self.Owner:Health() > 0 ) then
			if( self.Owner:GetVar( "player_model", NULL ) != NULL ) then
				self.Owner:SetModel( self.Owner:GetVar( "player_model", NULL ) )
			end
		end
	end

	self:KillSounds()
end

function SWEP:Holster( wep )
	if( CLIENT ) then return end
	
	if( !IsFirstTimePredicted() ) then return end

	self.Owner:DoAnimationEvent( ACT_GMOD_IN_CHAT )
	self.Owner:ManipulateBoneAngles( self.Owner:LookupBone( "ValveBiped.Bip01_R_Clavicle" ), Angle( 0, 0, 0 ) )
	self.Owner:ManipulateBoneAngles( self.Owner:LookupBone( "ValveBiped.Bip01_L_Clavicle" ), Angle( 0, 0, 0 ) )
	self.Owner:ManipulateBoneAngles( self.Owner:LookupBone( "ValveBiped.Bip01_R_Forearm" ), Angle( 0, 0, 0 ) )
	self.Owner:ManipulateBoneAngles( self.Owner:LookupBone( "ValveBiped.Bip01_L_Forearm" ), Angle( 0, 0, 0 ) )
	self.Owner:ManipulateBoneAngles( self.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" ), Angle( 0, 0, 0 ) )
	self.Owner:ManipulateBoneAngles( self.Owner:LookupBone( "ValveBiped.Bip01_L_Hand" ), Angle( 0, 0, 0 ) )
	self:SetVar( "anim_reset", true )
	if(self.Owner:GetModel() == "models/sansplayer/sansplayer.mdl") then
		self.Owner:SetBodygroup( 1, 0 )
		self.Owner:SetBodygroup( 2, 0 )
	end

	if(self.Owner:GetModel() == "models/nia/sans_pm.mdl") then
		self.Owner:SetBodygroup( 2, 0 )
	end

	if( self.Owner:IsValid() ) then
		if( self.Owner:Health() > 0 ) then
			//print( wep, wep:GetClass() )
			self.Owner:SetActiveWeapon( wep )
			//self.Owner:SelectWeapon( wep:GetClass() ) 
			if( self.Owner:GetVar( "player_model", NULL ) != NULL ) then
				self.Owner:SetModel( self.Owner:GetVar( "player_model", NULL ) )
			end
		end
	end

	if( self:GetVar( "grabbedEnt" ) ) then
		self:SetVar( "grabbedEnt", nil )
	end
	
	if ( self.BeatSound ) then self.BeatSound:ChangeVolume( 0, 0.1 ) end
	return true
end

//local grabbedEnt
//local distance
local max = 200
//local blockTelekinesis
//local invincible

function SWEP:Think()
	// Telekinesis
	local EyeTrace = self.Owner:GetEyeTrace()
	local grabbedEnt = self:GetVar( "grabbedEnt", NULL )
	local distance = self:GetVar( "distance", NULL )
	local blockBoneGround = self:GetVar( "blockBoneGround", NULL )
	
	if( CLIENT ) then return end
	if( self.Owner:GetVelocity():Length() < 30 || self.Owner:GetMoveType() == MOVETYPE_NOCLIP ) then
		//self.Owner:DoAnimationEvent( ACT_HL2MP_IDLE )
		
		if( self:GetVar( "anim_reset" ) != NULL ) then
			if(self.Owner:GetModel() == "models/nia/sans_pm.mdl") then
				self.Owner:ManipulateBoneAngles( self.Owner:LookupBone( "ValveBiped.Bip01_R_Clavicle" ), Angle( 0, 10, -40 ) )
				self.Owner:ManipulateBoneAngles( self.Owner:LookupBone( "ValveBiped.Bip01_L_Clavicle" ), Angle( 0, 10, 30 ) )
				self.Owner:ManipulateBoneAngles( self.Owner:LookupBone( "ValveBiped.Bip01_R_Forearm" ), Angle( 0, -90, 0 ) )
				self.Owner:ManipulateBoneAngles( self.Owner:LookupBone( "ValveBiped.Bip01_L_Forearm" ), Angle( 0, -90, 0 ) )
				self.Owner:ManipulateBoneAngles( self.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" ), Angle( 180, 0, 0 ) )
				self.Owner:ManipulateBoneAngles( self.Owner:LookupBone( "ValveBiped.Bip01_L_Hand" ), Angle( 180, 0, 0 ) )
			end
			if(self.Owner:GetModel() == "models/sansplayer/sansplayer.mdl") then
				self.Owner:ManipulateBoneAngles( self.Owner:LookupBone( "ValveBiped.Bip01_R_Clavicle" ), Angle( 0, 10, -30 ) )
				self.Owner:ManipulateBoneAngles( self.Owner:LookupBone( "ValveBiped.Bip01_L_Clavicle" ), Angle( 0, 10, 30 ) )
				self.Owner:ManipulateBoneAngles( self.Owner:LookupBone( "ValveBiped.Bip01_R_Forearm" ), Angle( 0, -60, 0 ) )
				self.Owner:ManipulateBoneAngles( self.Owner:LookupBone( "ValveBiped.Bip01_L_Forearm" ), Angle( 0, -60, 0 ) )
			end
			self:SetVar( "anim_reset", NULL )
		end
	else
		if( self:GetVar( "anim_reset" ) == NULL && self.Owner:GetVelocity():Length() > 150 ) then
			self:SetVar( "anim_reset", true )
			
			//self.Owner:DoAnimationEvent( ACT_GMOD_IN_CHAT )
			self.Owner:ManipulateBoneAngles( self.Owner:LookupBone( "ValveBiped.Bip01_R_Clavicle" ), Angle( 0, 0, 0 ) )
			self.Owner:ManipulateBoneAngles( self.Owner:LookupBone( "ValveBiped.Bip01_L_Clavicle" ), Angle( 0, 0, 0 ) )
			self.Owner:ManipulateBoneAngles( self.Owner:LookupBone( "ValveBiped.Bip01_R_Forearm" ), Angle( 0, 0, 0 ) )
			self.Owner:ManipulateBoneAngles( self.Owner:LookupBone( "ValveBiped.Bip01_L_Forearm" ), Angle( 0, 0, 0 ) )
			self.Owner:ManipulateBoneAngles( self.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" ), Angle( 0, 0, 0 ) )
			self.Owner:ManipulateBoneAngles( self.Owner:LookupBone( "ValveBiped.Bip01_L_Hand" ), Angle( 0, 0, 0 ) )
		end
	end

	if(self.Owner:GetModel() == "models/sansplayer/sansplayer.mdl") then
		self.Owner:SetBodygroup( 1, 1 )
		self.Owner:SetBodygroup( 2, 1 )
	end

	if(self.Owner:GetModel() == "models/nia/sans_pm.mdl") then
		self.Owner:SetBodygroup( 2, 2 )
	end

	
	if( self:GetVar( "btm_client" ) == NULL ) then
		//print( "sand " )

		self:SetVar( "btm_client", true )
	end
		
	if( self.Owner:KeyPressed( IN_RELOAD ) && self:GetVar( "blockBoneGround" ) == 0 ) then
		self:SetVar( "blockBoneGround", CurTime() + 0.5 )
		
		local tr = util.TraceLine( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:EyeAngles():Forward() * 10000,
			filter = function( ent ) if ( ent:GetClass() == "prop_physics" ) then return false end end
		} )

		local pos = tr.HitPos
		local rad = 30
		
		sound.Play( Sound( "undertale/bone_start.wav" ), tr.HitPos )
		
		for i = 1, 15 do
			local vec = Vector( math.Rand( -rad, rad ), math.Rand( -rad, rad ), 0 )
			vec:Rotate( tr.HitNormal:Angle() + Angle( 90, 0, 0 ) )
			local ang = ( tr.HitNormal * 2 + VectorRand() ):Angle()
			
			local traceGrd = util.TraceLine( {
				start = pos + vec,
				endpos = pos + vec - ang:Up() * 50,
				filter = function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end
			} )
			
			if( traceGrd.Hit ) then
				local ent = ents.Create( "ent_underboner_bone_ground" )
				ent:SetAngles( ang + Angle( 90, 0, 0 ) )
				ent:SetVar( "pos", pos )
				ent:SetVar( "normal", tr.HitNormal )
				ent:SetPos( traceGrd.HitPos )
				ent:SetOwner( self.Owner )
				//ent:EmitSound( "undertale/bone_start.wav", 75, 100, 1, CHAN_AUTO )
				ent:Spawn()
			end
		end
	end
	
	if( CurTime() > self:GetVar( "blockBoneGround" ) ) then
		self:SetVar( "blockBoneGround", 0 )
	end
	
	//if( blockTelekinesis == 0 ) then
		if( self.Owner:KeyPressed( IN_USE ) && EyeTrace.Entity:IsValid() ) then
			if( EyeTrace.Entity:IsNPC() || EyeTrace.Entity:IsPlayer() ) then
				self.Owner:EmitSound( Sound( "undertale/sans/active.wav" ), 75, 100, 1, CHAN_AUTO )
				
				self:SetVar( "grabbedEnt", EyeTrace.Entity )
				grabbedEnt = self:GetVar( "grabbedEnt", NULL )
				
				self:SetVar( "distance", math.max( max, self.Owner:GetPos():Distance( grabbedEnt:GetPos() ) ) )
				self:SetWeaponHoldType( "magic" )
			end
		end

		if( grabbedEnt:IsValid() ) then				
			local eyeAng = self.Owner:GetAngles()
			
			self.Owner:ManipulateBoneAngles( self.Owner:LookupBone( "ValveBiped.Bip01_R_Clavicle" ), Angle( 0, 0, 0 ) )
			self.Owner:ManipulateBoneAngles( self.Owner:LookupBone( "ValveBiped.Bip01_R_Clavicle" ), Angle( 0, 20, 45 - eyeAng.x ) )
			
			if( self.Owner:KeyReleased( IN_USE ) ) then
				self:SetVar( "anim_reset", true )
				self:SetVar( "grabbedEnt", nil )
			end
		end
	//end
	
	if( grabbedEnt != nil ) then
		if( grabbedEnt:IsValid() ) then
			
			local EyeDir = ( EyeTrace.HitPos - self.Owner:GetShootPos() )
			EyeDir:Normalize()

			grabbedEnt:SetVelocity( ( self.Owner:GetShootPos() + EyeDir * distance - Vector( 0, 0, grabbedEnt:GetModelRadius() / 2 ) - grabbedEnt:GetPos() ) * 10 - grabbedEnt:GetVelocity() )
			
			if( self:GetVar( "invincible" ) == 0 ) then
				local tr = util.TraceHull( {
					start = grabbedEnt:GetPos(),
					endpos = grabbedEnt:GetPos() + grabbedEnt:GetVelocity() / 40,
					filter = grabbedEnt,
					mins = grabbedEnt:OBBMins(),
					maxs = grabbedEnt:OBBMaxs()
				} )
				
				if( tr.HitWorld && grabbedEnt:GetVelocity():Length() > 200 ) then
					self:SetVar( "invincible", CurTime() )
				
					grabbedEnt:TakeDamage( grabbedEnt:GetVelocity():Length() / 100, self.Owner, self.Owner )
					
					grabbedEnt:EmitSound( Sound( "undertale/sans/smash.wav" ), 75, 100, 1, CHAN_AUTO ) 
					//EmitSound( Sound( sound ),grabbedEnt:GetPos() )
				end
			elseif ( CurTime() - self:GetVar( "invincible" ) ) >= 0.5 then
				self:SetVar( "invincible", 0 )
			end
		end
	end
end

function SWEP:PrimaryAttack()
	if( CLIENT ) then return end
	
	//if( !self:GetVar( "grabbedEnt", NULL ):IsValid() ) then
	
		self:SetNextPrimaryFire( CurTime() + 0.2 )
		self:SetNextSecondaryFire( CurTime() + 0.1 )
		
		local ent = ents.Create( "ent_underboner_gaster_blaster" )
		local rand = math.Rand( -math.pi, math.pi ) / 2
		local vec = Vector( 0, math.sin( rand ) * 70, 100 + math.cos( rand ) * 50 )
		
		vec:Rotate( Angle( 0, self.Owner:GetAngles().y, 0 ) )
		local pos = self.Owner:GetPos() + vec

		ent:SetAngles( ( self.Owner:GetEyeTrace().HitPos - pos ):Angle() )
		ent:SetPos( self.Owner:GetPos() )
		ent:EmitSound( Sound( "undertale/gaster_blaster/gaster_blaster_start.mp3" ), 75, 100, 1, CHAN_AUTO )
		ent:SetOwner( self.Owner )
		ent:Spawn()
		ent:SetVar( "position", pos )
	//end
end

function SWEP:SecondaryAttack()
	if( CLIENT ) then return end
	
	local entGrabbed = self:GetVar( "grabbedEnt", NULL )
	if( !entGrabbed:IsValid() ) then
		//self:SetVar( "reloadGB", 25 )
		self:SetNextPrimaryFire( CurTime() + 0.2 ) 
		self:SetNextSecondaryFire( CurTime() + 0.1 )
		
		local ent = ents.Create( "ent_underboner_bone_throw" )
		local side
		
		if( math.Round( math.Rand( 0, 1 ) ) == 0 ) then
			side = 1
		else
			side = -1
		end
		
		local pos = self.Owner:GetShootPos() + self.Owner:EyeAngles():Right() * 40 * side

		ent:SetPos( pos )
		ent:SetAngles( ( self.Owner:GetEyeTrace().HitPos - pos ):Angle() + Angle( 90, 0, 0 ) )
		ent:EmitSound( Sound( "undertale/bone_end.wav" ), 75, 100, 1, CHAN_AUTO )
		ent:SetOwner( self.Owner )
		ent:Spawn()
		
		local phys = ent:GetPhysicsObject()
		phys:SetVelocity( ent:GetUp() * 10000 )
	else
		self:SetNextSecondaryFire( CurTime() + 0.5 )
		
		for cycles = 1, 4 do
			local ent = ents.Create( "ent_underboner_bone_throw" )
			local dir = VectorRand()
			dir:Normalize()
			
			local minb, maxb = entGrabbed:GetCollisionBounds()
			local pos = entGrabbed:GetPos() + Vector( 0, 0, maxb.z / 2 ) + dir * 100

			ent:SetPos( pos )
			ent:SetOwner( self.Owner )
			ent:SetAngles( ( entGrabbed:GetPos() + Vector( 0, 0, 50 ) - pos ):Angle() + Angle( 90, 0, 0 ) )
			//ent:EmitSound( Sound( "undertale/bone_end.wav" ), 75, 100, 1, CHAN_AUTO )
			ent:Spawn()
			
			local phys = ent:GetPhysicsObject()
			phys:SetVelocity( ent:GetUp() * 2000 )
		end
	end
end