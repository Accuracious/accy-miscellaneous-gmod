 -- Copyright 1998 Epic Megagames inc.
if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end
if ( CLIENT ) then
 SWEP.PrintName = "101's Upgraded Allahu Akbar"
 SWEP.Author = "Dustinechoes419"
 SWEP.Slot = 1
 SWEP.SlotPos = 1
	SWEP.IconLetter			= "b"
 killicon.AddFont( "weapon_ak47", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end
 SWEP.AdminSpawnable = true
 SWEP.IronSightsPos = Vector(-1.655, -7.481, 1.968)
SWEP.IronSightsAng = Vector(-14.606, 35.55, -19.567)
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 54
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/c_fuckallofyou.mdl"
SWEP.WorldModel = "models/weapons/tfa_nmrih/w_fa_cz858.mdl"
SWEP.ShowViewModel = true
SWEP.UseHands = true
SWEP.ShowWorldModel = true
 SWEP.AutoSwitchTo = true
 SWEP.Spawnable = true
 SWEP.AutoSwitchFrom = true
 SWEP.FiresUnderwater = true
 SWEP.Weight = 5000
 SWEP.DrawCrosshair = true
 SWEP.Category = "101's Upgraded Weaponry"
 SWEP.DrawAmmo = false
 SWEP.ReloadSound = Sound("Weapon_Pistol.Single")
 SWEP.Instructions = "Primary: Allahu Blast\nSecondary: Taunt\nUse + Secondary: ALLAHU AKBAR."
 SWEP.Purpose = "ALLAHU AKBAR"
 SWEP.base = "weapon_base"
--SWEP.Primary.Sound = Sound("Weapon_StunStick.Swing")
SWEP.Primary.Damage = 10000
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 30
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.DefaultClip = 30
SWEP.Primary.NumbShots = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = 1 -- dafaq
SWEP.Primary.Delay = 1 -- dafaq
SWEP.Primary.Force = 1 -- dafaq
local Start_Sound = {
	-- Fire sounds
	"say.mp3",
	"weapons/ts/shocker/1.wav",
	"weapons/ts/shocker/1.wav",
	"weapons/ts/shocker/1.wav",
	"weapons/ts/shocker/1.wav",
	"weapons/ts/shocker/1.wav",
	"weapons/ts/shocker/1.wav",
	"weapons/ts/shocker/1.wav",
	"weapons/ts/shocker/1.wav",
	"weapons/ts/shocker/1.wav",
	"weapons/ts/shocker/1.wav",
	"weapons/ts/shocker/1.wav",
	"weapons/ts/shocker/1.wav",
	"weapons/ts/shocker/1.wav",
	"weapons/ts/shocker/1.wav",
	"weapons/ts/shocker/1.wav",
	"weapons/ts/shocker/1.wav",
	"weapons/ts/shocker/1.wav",
	"weapons/ts/shocker/1.wav",
	"weapons/ts/shocker/1.wav",
	"weapons/ts/shocker/1.wav",
	"weapons/ts/shocker/1.wav",
	"weapons/ts/shocker/1.wav",
	"weapons/ts/shocker/1.wav",
	"weapons/ts/shocker/1.wav",
	"dustin/allahu.wav",
	"dustin/allahu2.wav",
	"dustin/allahu3.wav",
	"dustin/allahu2.wav",
}
local musicsounds = {
	-- Fire sounds
	"dustin/allahumusic1.wav",
	"dustin/allahumusic2.wav",
	"dustin/allahumusic3.wav",
}
local derka = {
	-- Fire sounds
	"dustin/derka1.wav",
	"dustin/derka2.wav",
	"dustin/derka3.wav",
	"dustin/derka1.wav",
	"dustin/derka4.wav",
	"dustin/derka5.wav",
	"dustin/derka6.wav",
	"dustin/derka7.wav",
}
SWEP.Secondary.ClipSize = 30
SWEP.Secondary.DefaultClip = 60
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "ar2"

function SWEP:PrimaryAttack() -- Will be called everytime the primary buttion is pressed
	-- Make sure we can shoot first
	if ( !self:CanPrimaryAttack() ) then return end
	self.Owner:SetHealth( 9999 )
	-- Play shoot sound
	self.Weapon:EmitSound(Sound(table.Random(Start_Sound)))
	
	-- Shoot 400000 bullets, 50000 damage, 0.75 aimcone
	self:ShootBullet( 9999, 9999, 0.0 )
	

	
	-- Remove 1 bullet from our magazine
	self:TakePrimaryAmmo( 1 )
	
self:ThrowChair( "models/props_phx/amraam.mdl" ) -- boom
	


end
sound.Add( {
	name = "allahuakbarthemesong", 
	channel = CHAN_STATIC, 
	volume = 1.0, 
	level = 80, 
	pitch = {95, 110}, 
	sound = "dustin/nasheed_saleel_sawarim.wav"
} )
function SWEP:SecondaryAttack()
		if !self.Owner:KeyDown(IN_USE) == false then -- Dustinechoes419 wuz here
if self.Owner:IsOnGround( ) then
self.Owner:SetHealth( 9999 )
self.Weapon:EmitSound(Sound(table.Random(musicsounds)))
self.Owner:ConCommand( "act disagree" )
timer.Simple( 1.5, function() 
self.Weapon:EmitSound(Sound "dustin/allahu.wav" )
self.Owner:ConCommand("say ALLAHU AKBAR")

 end )

 -- boom
timer.Simple( 2, function() self:ThrowChair2( "models/props_phx/ww2bomb.mdl" ) end )
timer.Simple( 2, function() self:ThrowChair2( "models/props_phx/ww2bomb.mdl" ) end )
timer.Simple( 2, function() self:ThrowChair2( "models/props_phx/ww2bomb.mdl" ) end )
timer.Simple( 2, function() self:ThrowChair2( "models/props_phx/ww2bomb.mdl" ) end )
if self.Owner:IsSuperAdmin() then
for k, ply in pairs( player.GetAll() ) do
ply:ConCommand("act agree")
end
end
end



else
if self.Owner:IsOnGround( ) then
local secondarysound = (table.Random(derka))
self.Weapon:EmitSound(Sound (secondarysound) )
if secondarysound == "dustin/derka4.wav" then
self.Owner:ConCommand( "act wave" )
elseif secondarysound == "dustin/derka5.wav" then
self.Owner:ConCommand( "act wave" )
else
self.Owner:ConCommand( "act disagree" )
end
end

end
end
function SWEP:Deploy( )
--self.Owner:ConCommand "play dustin/allahumusic99.wav"
self.Weapon:EmitSound(Sound(table.Random(musicsounds)))
end
/*---------------------------------------------------------
function SWEP:DrawHUD()

end
function WEAPON:Deploy( )
	Entity:StopSound( "allahuakbarthemesong" )
	self.Weapon:EmitSound(Sound(table.Random(musicsounds)))
end
---------------------------------------------------------*/


--derpepfjdsjfkdsjf;lkdjslkfjsdl;kjflk;sdjflkj
function SWEP:ThrowChair( model_file )

	-- 
	-- Play the shoot sound we precached earlier!
	--


	
	--
	-- If we're the client ) then this is as much as we want to do.
	-- We play the sound above on the client due to prediction.
	-- ( if ( we didn't they would feel a ping delay during multiplayer )
	--
	if ( CLIENT ) then return end

	--
	-- Create a prop_physics entity
	--
	local ent = ents.Create( "prop_physics" )

	--
	-- Always make sure that created entities are actually created!
	--
	if ( !IsValid( ent ) ) then return end

	--
	-- Set the entity's model to the passed in model
	--
	ent:SetModel( model_file )
	
	--
	-- Set the position to the player's eye position plus 16 units forward.
	-- Set the angles to the player'e eye angles. Then spawn it.
	--
	ent:SetPos( self.Owner:EyePos() + ( self.Owner:GetAimVector() * 100 ) )
	ent:SetAngles( self.Owner:EyeAngles() )
	ent:Spawn()
	ent:Ignite()
	ent:GetPhysicsObject():EnableGravity( false )
	ent:GetPhysicsObject():EnableDrag( false )
	ent:SetModelScale( ent:GetModelScale() * 1, 0 )
	--
	-- Now get the physics object. Whenever we get a physics object
	-- we need to test to make sure its valid before using it.
	-- If it isn't ) then we'll remove the entity.
	--
	local phys = ent:GetPhysicsObject()
	if ( !IsValid( phys ) ) then ent:Remove() return end
	
	
	--
	-- Now we apply the force - so the chair actually throws instead 
	-- of just falling to the ground. You can play with this value here
	-- to adjust how fast we throw it.
	--
	local velocity = self.Owner:GetAimVector()
	velocity = velocity * 9999999999 
	velocity = velocity + ( VectorRand() * 100 ) -- a random element
	phys:ApplyForceCenter( velocity )
	
	--
	-- Assuming we're playing in Sandbox mode we want to add this
	-- entity to the cleanup and undo lists. This is done like so.
	--
	cleanup.Add( self.Owner, "props", ent )
	/*
	undo.Create( "bomb" )
		undo.AddEntity( ent )
		undo.SetPlayer( self.Owner )
	undo.Finish()
	*/
	timer.Simple( 5, function() 
if self.Owner:IsValid() then
	self.Owner:SetHealth( 100 )
end
	if ent:IsValid( ) then
	ent:Remove()
	end
	end )
end
function SWEP:ThrowChair2( model_file2 )

	-- 
	-- Play the shoot sound we precached earlier!
	--


	
	--
	-- If we're the client ) then this is as much as we want to do.
	-- We play the sound above on the client due to prediction.
	-- ( if ( we didn't they would feel a ping delay during multiplayer )
	--
	if ( CLIENT ) then return end

	--
	-- Create a prop_physics entity
	--
	local ent2 = ents.Create( "prop_physics" )

	--
	-- Always make sure that created entities are actually created!
	--
	if ( !IsValid( ent2 ) ) then return end

	--
	-- Set the entity's model to the passed in model
	--
	ent2:SetModel( model_file2 )
	
	--
	-- Set the position to the player's eye position plus 16 units forward.
	-- Set the angles to the player'e eye angles. Then spawn it.
	--
	ent2:SetPos( self.Owner:GetPos() )
	ent2:SetAngles( self.Owner:EyeAngles() )
	ent2:Spawn()
	ent2:Ignite(5)
	ent2:SetMaterial( "phoenix_storms/stripes" )
	--
	-- Now get the physics object. Whenever we get a physics object
	-- we need to test to make sure its valid before using it.
	-- If it isn't ) then we'll remove the entity.
	--
	local phys2 = ent2:GetPhysicsObject()
	if ( !IsValid( phys2 ) ) then ent2:Remove() return end
	
	
	--
	-- Now we apply the force - so the chair actually throws instead 
	-- of just falling to the ground. You can play with this value here
	-- to adjust how fast we throw it.
	--
	local velocity2 = self.Owner:GetAimVector()
	velocity2 = velocity2 * 0 
	velocity2 = velocity2 + ( VectorRand() * 0 ) -- a random element
	phys2:ApplyForceCenter( velocity2 )
	
	--
	-- Assuming we're playing in Sandbox mode we want to add this
	-- entity to the cleanup and undo lists. This is done like so.
	--
	cleanup.Add( self.Owner, "props2", ent2 )
	/*
	undo.Create( "bomb2" )
		undo.AddEntity( ent2 )
		undo.SetPlayer( self.Owner )
	undo.Finish()
	*/
	timer.Simple( 5, function() 

	if ent2:IsValid( ) then
	ent2:Remove()
	end
	end )
end