package com.lingzhimobile.nutritionfoodguide;



import android.content.Context;
import android.content.res.TypedArray;
import android.util.AttributeSet;
import android.util.Log;
import android.widget.*;

public class TextViewSimpleVertical extends TextView{
	static final String LogTag = "TextViewSimpleVertical";
	
	CharSequence m_textVertical, m_textOriginal;
	
	public TextViewSimpleVertical(Context context) {
		super(context);
		this.readStyleParameters(context, null);
	}

	public TextViewSimpleVertical(Context context, AttributeSet attrs) {
		super(context, attrs);
		this.readStyleParameters(context, attrs);
	}
	
	public TextViewSimpleVertical(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        this.readStyleParameters(context, attrs);
    }
	
	private void readStyleParameters(Context context, AttributeSet attributeSet) {
        TypedArray a = context.obtainStyledAttributes(attributeSet, R.styleable.TextViewSimpleVertical);
        try {
        	CharSequence text1 = a.getText(R.styleable.TextViewSimpleVertical_textVertical);
        	setTextVertical(text1);
        } finally {
            a.recycle();
        }
    }
	

    public void setTextVertical(CharSequence text) {
    	m_textOriginal = text;
    	m_textVertical = getVerticalText(m_textOriginal);
        setText(m_textVertical);
    }
    public void setTextVertical(int resid) {
    	CharSequence text = getContext().getResources().getText(resid);
    	setTextVertical(text);
    }
    
    static CharSequence getVerticalText(CharSequence text){
    	if (text == null){
    		return text;
    	}else{
    		String s1 = text.toString();
    		StringBuffer sb2 = new StringBuffer(s1.length()*2);
    		for (int i = 0; i < s1.length(); i++) {
				sb2.append(s1.charAt(i));
				if (i<s1.length()-1)
					sb2.append("\n");
			}
    		return sb2.toString();
    	}
    }


    
    
    

}
