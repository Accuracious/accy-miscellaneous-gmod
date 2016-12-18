AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.Editable		= true
ENT.PrintName		= "Undertale Gaster Blaster"
ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false

if( CLIENT ) then killicon.Add( "ent_undertale_gaster_blaster", "undertale/killicon_gaster_blaster", color_white ) end

local modelAvailible = true

function ENT:Initialize()
	if( SERVER ) then
		local model = "models/theforgottenarchitect/props/bullets/308winchester.mdl"
		if( !util.IsValidModel( model ) ) then model = "models/Gibs/HGIBS.mdl" modelAvailible = false end
		
		self:SetModel( model )
		self:SetTrigger( true )
		//self.Entity:PhysicsInit(SOLID_BBOX)
		//self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		//self.Entity:SetSolid(SOLID_BBOX)
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_NONE )
		
		self:SetVar( "open", CurTime() + 0.0 )
		self:SetVar( "CurTime", math.Rand( 0, 0 ) )
		
		self:ManipulateBoneAngles( 0, Angle( 0, 0, 90 ) )
		self:ManipulateBoneAngles( 1, Angle( 90, 0, 0 ) )
		self:ManipulateBonePosition( 0, Vector( -0.5, 0, -0.8 ) )
		self:ManipulateBonePosition( 1, Vector( -0.5, 0, -0.8 ) )
		
		local phys = self:GetPhysicsObject()
		if( IsValid( phys ) ) then
			phys:Wake()
		end
		
		util.AddNetworkString( "gaster_blaster_shooting" )
	end
	
	if( CLIENT ) then
		self:SetVar( "shootEffect", 0 )
	end
end

function ENT:PhysicsUpdate()
	if( SERVER ) then
		local pos = self:GetVar( "position", NULL )
		local dist = pos:Distance( self:GetPos() )
		
		if( self:GetVar( "distance", NULL ) == NULL ) then
			self:SetVar( "distance", dist )
			self:SetVar( "scale", self:GetModelScale() )
		end
		
		local scale = self:GetVar( "scale", NULL )
		local saveDist = self:GetVar( "distance" )
		local curtime = CurTime() - self:GetVar( "CurTime", NULL )
		local vec = Vector( math.cos( curtime ), math.sin( curtime ), math.sin( curtime ) / 2 )
		
		local numb = ( CurTime() - self:GetVar( "open", NULL ) ) * 6
		
		if( numb < 3 ) then
			self:SetPos( self:GetPos() + ( pos - self:GetPos() ) / 10 + vec * math.max( 0.5, dist / 30 ) )
		else
			if( numb > 10 ) then
				self:Remove()
			end
			self:SetPos( self:GetPos() - self:GetForward() * ( dist / 10 + 0.1 ) )
		end
		
		if( dist < 15 ) then
			local value = math.sin( math.max( 0, math.min( 2, numb ) ) ) * 1.1

			if( numb > 0 ) then
			
				if( self:GetVar( "shoot", NULL ) == NULL ) then
					self:SetVar( "shoot", true )
					
					self:EmitSound( "undertale/gaster_blaster/gaster_blaster_end.mp3", 75, 100, 1, CHAN_AUTO )
					
					local tr = util.TraceHull( {
						start = self:GetPos(),
						endpos = self:GetPos() + self:GetForward() * 10000,
						filter = function( ent )
							if ent == self.Owner then return end
							
							if( ent:IsValid() ) then
								ent:TakeDamage( 999999999, self.Owner, self )
								if( ent:IsValid() ) then
									return false
								end
							end
						end,
						mins = Vector( -20, -20, -20 ),
						maxs = Vector( 20, 20, 20 ),
						mask = MASK_SHOT_HULL
					} )
					
					net.Start( "gaster_blaster_shooting" )
					net.WriteEntity( self )
					net.Broadcast()
				end
				
				self:ManipulateBoneScale( 0, Vector( 0, 0, 0 ) )

				self:GetPhysicsObject():Wake()
				if( modelAvailible ) then
					self:SetModelScale( scale * 25 )
				else
					self:SetModelScale( scale * 5 )
				end
			end
		else
			if( modelAvailible ) then
				self:SetModelScale( scale * math.max( 0, math.min( 1, ( saveDist - dist ) / saveDist ), 0 ) * 20 )
			else
				self:SetModelScale( scale * math.max( 0, math.min( 1, ( saveDist - dist ) / saveDist ), 0 ) * 5 )
			end
		end
	end
end

net.Receive( "gaster_blaster_shooting", function()
	local read = net.ReadEntity()
	read:SetVar( "shootEffect", CurTime() )
end )

function ENT:Draw()
	
	self:DrawModel()
	
	if( self:GetVar( "shootEffect", NULL ) > 0 ) then
		numb = CurTime() - self:GetVar( "shootEffect", NULL ) 
		if( numb > 1 ) then
			self:SetVar( "shootEffect", 0 )
		end
		
		local tr = util.TraceLine( {
			start = self:GetPos(),
			endpos = self:GetPos() + self:GetForward() * 10101,
			filter = function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end
		} )
		
		render.SetMaterial( Material( "Models/effects/vol_light001" ) )
		render.SetColorMaterial( 170, 139, 207 )
		
		local size = math.max( 0, math.min( 1, math.sin( numb * 5 ) * 1.4 ) )
		local pos = self:GetPos() - self:GetUp() * 20 - self:GetForward() * 10
		local dir = tr.HitPos - pos
		dir:Normalize()
		
		local length = 25
		
		for i = 1, 5 do
			local forw = ( 17 + i * ( length / 5 ) )
			render.DrawBeam( pos + dir * ( forw - ( length / 5 ) ), pos + dir * forw, ( 15 + 3 * i ) * size, 1, 1, Color( 170, 139, 207, 255 ) ) 
		end
		
		render.DrawBeam( pos + dir * ( 16 + length ), tr.HitPos, 30 * size, 1, 1, Color( 170, 139, 207, 255 ) )
	end
end