local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

return function(DragPoint, Main)
	local dragging, dragInput, mousePos, framePos

	DragPoint.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			mousePos = input.Position
			framePos = Main.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	DragPoint.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - mousePos
			TweenService:Create(Main, TweenInfo.new(
				0.05,
				Enum.EasingStyle.Quint,
				Enum.EasingDirection.Out
			), {
				Position = UDim2.new(
					framePos.X.Scale, framePos.X.Offset + delta.X,
					framePos.Y.Scale, framePos.Y.Offset + delta.Y
				)
			}):Play()
		end
	end)
end
