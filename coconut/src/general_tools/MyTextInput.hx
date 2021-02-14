package general_tools;


import coconut.vdom.View;
import coconut.vdom.*;
import bootstrap.*;
import bootstrap.types.Size;
import bootstrap.types.Variant;
import tink.domspec.ClassName;

class MyTextInput extends View {
	static inline final prefix:String = 'form-control';

	@:attribute var variant:Variant = Primary;
	@:attribute var size:Size = Size.Default;
	@:attribute var block:Bool = false;
	@:attribute var active:Bool = false;
	@:attribute var disabled:Bool = false;
	@:attribute var type:InputType = InputType.Text;

	@:attribute var id:String = "";
	@:attribute var placeholder:String = "";

	@:attribute var className:ClassName = null;
	@:attribute var label:String = null;

	//@:controlled var val:String = "";

	@:attribute var onTextChange:String->Void = function(v:String){};

	function updateValue(v) {
		onTextChange(v);
	}

	function render()
		'
		<let classes=${className.add([
			'${prefix}' => true,
			'${prefix}-${variant}' => true,
			'${prefix}-${size}' => size != null,
			'${prefix}-block' => block,
			'${prefix}-disabled' => disabled,
			'active' => active,
		])}>
			<input type="${type}"
			className="${classes}"
			oninput=${event -> updateValue(event.currentTarget.value)}
			id="${id}"
			disabled=${disabled}
			placeholder="${placeholder}">
			</input>
		</let>
	';
}
// oninput=${event -> update(event)}
// <input type="${type}" className=${classes} id="${id}" disabled=${disabled} placeholder="${placeholder} onTextChange={setVal} "></input>
// <input type="${type}" className=${classes} id="${id}" disabled=${disabled} placeholder="${placeholder}">${...children}</input>
