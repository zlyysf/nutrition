package com.lingzhimobile.nutritionfoodguide;



import android.app.AlertDialog;

import android.content.Context;
import android.content.DialogInterface;

import android.text.Selection;
import android.text.Spannable;
import android.util.Log;
import android.view.KeyEvent;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;

public class DialogHelperSimpleInput
{
	public interface InterfaceWhenConfirmInput{
		void onConfirmInput(String input);
	}
	
	static final String LogTag = "DialogHelperSimpleInput";
	
	protected Context mContext;
	protected AlertDialog.Builder m_DialogBuilder = null;
	protected EditText m_etInput = null;
	protected AlertDialog m_dialog;
//	protected boolean m_allowEmpty = false;
	protected InterfaceWhenConfirmInput m_InterfaceWhenConfirmInput;
	
	public DialogHelperSimpleInput(Context ctx) {
		mContext = ctx;
		m_DialogBuilder =new AlertDialog.Builder(mContext);
		m_etInput = new EditText(mContext);
//		m_allowEmpty = allowEmpty;
	}
	
	public EditText getInput(){
		return m_etInput;
	}
	public AlertDialog.Builder getDialogBuilder(){
		return m_DialogBuilder;
	}
	
	
	public void setInterfaceWhenConfirmInput(InterfaceWhenConfirmInput InterfaceWhenConfirmInput1){
		m_InterfaceWhenConfirmInput = InterfaceWhenConfirmInput1;
	}
	
	
	public void setInputType(int inputType){
		m_etInput.setInputType(inputType);
//		InputType.TYPE_CLASS_TEXT
//		InputType.TYPE_CLASS_NUMBER
	}
	
	public void prepareDialogAttributes(String title,String message,String initialValueForInput){
		m_DialogBuilder.setTitle(title);
		m_DialogBuilder.setMessage(message);
		m_etInput.setText(initialValueForInput);
	}
	public void prepareDialogAttributes(int id_title,int id_message,String initialValueForInput){
		m_DialogBuilder.setTitle(id_title);
		m_DialogBuilder.setMessage(id_message);
		m_etInput.setText(initialValueForInput);
	}

	public void show(){
		DialogInterfaceEventListener myDialogInterfaceEventListener = new DialogInterfaceEventListener();

		m_DialogBuilder.setView(m_etInput);
		m_DialogBuilder.setPositiveButton(R.string.OK, myDialogInterfaceEventListener);
		m_DialogBuilder.setNegativeButton(R.string.cancel, myDialogInterfaceEventListener);
		
		m_dialog = m_DialogBuilder.create();

		m_dialog.setOnShowListener(myDialogInterfaceEventListener);
//		m_dialog.setOnDismissListener(myDialogInterfaceEventListener);
		m_dialog.show();
	}
	
	class DialogInterfaceEventListener 
	implements DialogInterface.OnClickListener, DialogInterface.OnShowListener, DialogInterface.OnDismissListener, DialogInterface.OnCancelListener, DialogInterface.OnKeyListener{

		@Override
		public void onClick(DialogInterface dlgInterface, int which) {
			if(which == DialogInterface.BUTTON_POSITIVE){
				Log.d(LogTag, "onClick OK "+m_dialog);
				String sInput = m_etInput.getText().toString();
				
				if (m_InterfaceWhenConfirmInput!=null){
					m_InterfaceWhenConfirmInput.onConfirmInput(sInput);
				}
				
			}else if(which == DialogInterface.BUTTON_NEGATIVE){
				Log.d(LogTag, "onClick Cancel "+m_dialog);
			}else if(which == DialogInterface.BUTTON_NEUTRAL){//忽略按键的点击事件
				Log.d(LogTag, "onClick Ignore "+m_dialog);
			}else{
				Log.d(LogTag, "onClick other "+m_dialog);
			}
		}

		@Override
		public void onShow(DialogInterface dlgInterface) {
			Log.d(LogTag, "onShow "+m_dialog+ " | "+dlgInterface);
			InputMethodManager imm = (InputMethodManager) mContext.getSystemService(Context.INPUT_METHOD_SERVICE);
	        imm.showSoftInput(m_etInput, InputMethodManager.SHOW_IMPLICIT);//能show出键盘
	        
	        //文本框中的光标默认在最前，这里把光标移到最后
	        CharSequence text = m_etInput.getText();
	        if (text instanceof Spannable) {
	             Spannable spanText = (Spannable)text;
	             Selection.setSelection(spanText, text.length());
	        }
		}
		
		@Override
		public void onDismiss(DialogInterface dlgInterface) {
			Log.d(LogTag, "onDismiss "+m_dialog+ " | "+dlgInterface);
		}
		@Override
		public boolean onKey(DialogInterface dialog, int keyCode, KeyEvent event) {
			return false;
		}
		@Override
		public void onCancel(DialogInterface dlgInterface) {
			Log.d(LogTag, "onCancel "+m_dialog+ " | "+dlgInterface);
			
		}
	}//class DialogInterfaceEventListener
	
	
	
}
