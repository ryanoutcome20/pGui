function pGui:GenerateDropdown( Panel, Assignment, Index, Options, Width, useSort, useIndex, Callback )
    -- Have to generate the dropdowns used in the menu.
    
    Panel = Panel or self.Last

    local Dropdown = vgui.Create( 'DComboBox', Panel )
    Dropdown:SetSize( Width and self:Scale( Width ) or self:Scale( 100 ), 15 )
    Dropdown:Dock( RIGHT )
    Dropdown:DockMargin( self:Scale( 5 ), 0, self:Scale( 4 ), 0 )
    Dropdown:SetSortItems( useSort )

    Dropdown:SetValue( Options[ Index ] )
    pGui.Config[ Assignment ] = useIndex and Index - 1 or Options[ Index ]

    for i = 1, #Options do
        Dropdown:AddChoice( Options[ i ] )
    end

    Dropdown.OnSelect = function( self, Index, Value )
        pGui.Config[ Assignment ] = useIndex and Index - 1 or Value

        if ( Callback ) then 
            Callback( Value )
        end
    end

    Dropdown:SetFont( 'DefaultSmall' )
    
    -- This is terrible but I didn't make the library. You can tell this wasn't made for 
    -- dynamic guis.
    self:GenerateFixedDropdown( Dropdown )

    return Dropdown
end

function pGui:GenerateFixedDropdown( Dropdown )
    -- Fix the default box color.
    Dropdown.Paint = function( self, W, H )
        surface.SetDrawColor( pGui.Color )
        surface.DrawOutlinedRect( 0, 0, W, H, 1 )

        self:SetTextColor( pGui.Color )
    end

    -- Fix the default hover, clicked, and other colors.
    Dropdown.GetTextStyleColor = function( )
        return pGui.Color
    end

    Dropdown.SetTextStyleColor = function( )
        return pGui.Color
    end

    -- Fix the default dropdown arrow button.
    Dropdown.DropButton.Paint = function( self, W, H ) end

    -- Fix the entire dropdown menu and every color within the many sub panels.
    Dropdown.OnMenuOpened = function( self, Menu )
        -- Horrific code below. VGUI has forced my hand.

        local Children = self:GetChildren( )

        local childFrame = Children[ 1 ]
        local childMenu = Children[ 2 ]

        childFrame.Think = function( self )
            local Parent = self:GetParent( )
            
            if ( Parent and not Parent:IsVisible( ) ) then 
                return self:Remove( )
            end
        end

        childMenu.Paint = function( self, W, H )
            surface.SetDrawColor( 20, 20, 20, 250 )
            surface.DrawRect( 0, 0, W, H )
    
            surface.SetDrawColor( pGui.Color )
            surface.DrawOutlinedRect( 0, 0, W, H, 1 )

            -- Comical VGUI moment.
            local Parent = self:GetParent( )

            while ( true ) do
                local Sub = Parent:GetParent( )

                if ( not Sub ) then 
                    break
                end

                if ( Sub:GetClassName( ) == 'CGModBase' ) then 
                    break
                end
                
                Parent = Sub
            end

            if ( not Parent or not Parent:IsVisible( ) ) then
                self:Remove( ) 
            end
        end
    
        -- Fix the hover and highlight color.
        for i = 1, #Dropdown.Choices do 
            local Menu = childMenu:GetChild( i )

            Menu:SetColor( pGui.Colors.White )
        end

        -- Fix the blue hover color that it has by default.
        childMenu.OpenSubMenu = function( Sub )
            local subSub = Sub:GetChildren( )[ 1 ]
            
            local subSubChildren = subSub:GetChildren( )

            for i = 1, #Dropdown.Choices do 
                local subSubSub = subSubChildren[ i ]

                subSubSub.Paint = function( self, W, H )
                    if ( not self:IsHovered( ) ) then 
                        return 
                    end
                    
                    surface.SetDrawColor( pGui.Color )
                    surface.DrawOutlinedRect( 0, 0, W, H, 1 )
                end
            end
        end
    end
end