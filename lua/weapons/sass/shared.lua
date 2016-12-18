//Made by Macumba
SWEP.base = "weapon_base"
SWEP.Category = "Finger Weapons";
SWEP.Author = "A perverted mind.";
SWEP.Contact = "The perverted mind.";
SWEP.Purpose = "Bang those who please you.";
SWEP.Instructions = "Get horny then really feel it.";
SWEP.PrintName = "Sass.";
SWEP.Slot = 3;
SWEP.SlotPos = 0;
SWEP.DrawCrosshair = true;
SWEP.DrawAmmo = false;
SWEP.ViewModel = "models/weapons/v_shot_ts_theshocker.mdl";
SWEP.WorldModel = "models/Humans/Group02/Male_01.mdl";
SWEP.ViewModelFOV = 64;
SWEP.ViewModelFlip = true;
SWEP.ReloadSound = "say.mp3";
SWEP.HoldType = "pistol";
SWEP.Spawnable = true;
SWEP.AdminSpawnable = true;
SWEP.Weight = 1;
SWEP.AutoSwitchTo = false;
SWEP.AutoSwitchFrom = true;
SWEP.FiresUnderwater = true;

function SWEP:Deploy()
   self.Weapon:EmitSound("drool.mp3")
end

SWEP.Primary.ClipSize = 69;
SWEP.Primary.DefaultClip = 69;
SWEP.Primary.Recoil = 1;
SWEP.Primary.Damage = 1000;
SWEP.Primary.NumberofShots = 1;
SWEP.Primary.Spread = 0.1;
SWEP.Primary.Delay = 1.5;
SWEP.Primary.Automatic = true;
SWEP.Primary.Ammo = "Pistol";
SWEP.Primary.Sound = "say.mp3";
SWEP.Primary.Force = 1;
SWEP.Primary.TakeAmmo = 1;

SWEP.Secondary.Recoil = 1;
SWEP.Secondary.Damage = 1000;
SWEP.Secondary.NumberofShots = 1;
SWEP.Secondary.Spread = 0.1;
SWEP.Secondary.Delay = 0.2;
SWEP.Secondary.Automatic = true;
SWEP.Secondary.Ammo = "Pistol";
SWEP.Secondary.Sound = "vo/heavy_meleeing02.mp3";
SWEP.Secondary.Force = 20;
SWEP.Secondary.TakeAmmo = 1;

function SWEP:Initialize()
    util.PrecacheSound(self.Primary.Sound)
     util.PrecacheSound(self.Secondary.Sound)
    if ( SERVER ) then
       self:SetWeaponHoldType( self.HoldType )
   end
end

function SWEP:PrimaryAttack()
   if ( !self:CanPrimaryAttack() ) then return end
   local bullet = {};
       bullet.Num = self.Primary.NumberofShots;
       bullet.Src = self.Owner:GetShootPos();
       bullet.Dir = self.Owner:GetAimVector();
       bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0);
       bullet.Tracer = 0;
       bullet.Force = self.Primary.Force;
       bullet.Damage = self.Primary.Damage;
       bullet.AmmoType = self.Primary.Ammo;
   local rnda = -self.Primary.Recoil;
   local rndb = self.Primary.Recoil * math.random(-1, 1);
   self:ShootEffects();
   self.Owner:FireBullets( bullet );
   self.Weapon:EmitSound(Sound(self.Primary.Sound))
   self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) )
   self:TakePrimaryAmmo(self.Primary.TakeAmmo)
   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
    self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
end

function SWEP:SecondaryAttack()
 if ( !self:CanPrimaryAttack() ) then return end
   local bullet = {};
       bullet.Num = self.Secondary.NumberofShots;
       bullet.Src = self.Owner:GetShootPos();
       bullet.Dir = self.Owner:GetAimVector();
       bullet.Spread = Vector( self.Secondary.Spread * 0.1 , self.Secondary.Spread * 0.1, 0);
       bullet.Tracer = 0;
       bullet.Force = self.Secondary.Force;
       bullet.Damage = self.Secondary.Damage;
       bullet.AmmoType = self.Secondary.Ammo;
   local rnda = -self.Secondary.Recoil;
   local rndb = self.Secondary.Recoil * math.random(-1, 1);
   self:ShootEffects();
   self.Owner:FireBullets( bullet );
   self.Weapon:EmitSound(Sound(self.Secondary.Sound))
   self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) )
   self:TakePrimaryAmmo(self.Secondary.TakeAmmo)
   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
end

function SWEP:Think()

		if ( !self.Owner:KeyDown( IN_JUMP ) ) then return end
		local tracerlajn = {}
		local kickin = self.Owner:GetPos()
		tracerlajn.start = kickin
		tracerlajn.endpos = kickin - Vector(0,0,38)
		tracerlajn.filter = self.Owner
		local trace1 = util.TraceLine( tracerlajn )
		if SERVER then
		self.Owner:SetVelocity( self.Owner:GetAimVector() * 45 )
		end
end

function SWEP:Reload()
   self.Weapon:DefaultReload(ACT_VM_RELOAD)
   self.Weapon:EmitSound("good.mp3")
   return true
end

function SWEP:Holster()
   self.Weapon:EmitSound("vo/engineer_no01.mp3")
   return true
end

function SWEP:OnRestore()
end

function SWEP:Precache()
end

function SWEP:OwnerChanged()
end
