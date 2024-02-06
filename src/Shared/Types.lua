export type Character = Model & {
	Humanoid: (Humanoid & {Animator: Animator?, HumanoidDescription: HumanoidDescription?})?,
	HumanoidRootPart: Part?,
	Head: Part?,
	UpperTorso: MeshPart?,
	LowerTorso: MeshPart?,
	LeftUpperArm: MeshPart?,
	LeftLowerArm: MeshPart?,
	LeftHand: MeshPart?,
	RightUpperArm: MeshPart?,
	RightLowerArm: MeshPart?,
	RightHand: MeshPart?,
	LeftUpperLeg: MeshPart?,
	LeftLowerLeg: MeshPart?,
	LeftFoot: MeshPart?,
	RightUpperLeg: MeshPart?,
	RightLowerLeg: MeshPart?,
	RightFoot: MeshPart?
}

export type Event = {
	Callbacks : {};
	Waiting : {};
	Connect : (Event, func : () -> nil) -> Connection,
	Fire : (Event, ...any) -> nil,
	Wait : (Event) -> any
}

export type Connection = {
	Connected : boolean,
	Disconnect: () -> nil
}

return {}