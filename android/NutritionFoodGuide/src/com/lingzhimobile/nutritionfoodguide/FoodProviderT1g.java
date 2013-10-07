/*
 * Copyright (C) 2010 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.lingzhimobile.nutritionfoodguide;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;



import android.app.SearchManager;
import android.content.ContentProvider;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.UriMatcher;
import android.database.Cursor;
import android.database.MatrixCursor;
import android.net.Uri;
import android.provider.BaseColumns;
import android.util.Log;

/**
 * Provides access to the food database.
 */
public class FoodProviderT1g extends ContentProvider {
	static final String LogTag = "FoodProviderT1g";


	@Override
	public int delete(Uri uri, String selection, String[] selectionArgs) {
		return 0;
	}

	@Override
	public String getType(Uri uri) {
		return null;
	}

	@Override
	public Uri insert(Uri uri, ContentValues values) {
		return null;
	}

	@Override
	public boolean onCreate() {
		return true;
	}

	@Override
	public Cursor query(Uri uri, String[] projection, String selection,
			String[] selectionArgs, String sortOrder) {
		Log.d(LogTag, "query enter, uri="+uri.toString()+", projection="+projection+", selection="+selection+", selectionArgs="+selectionArgs);
		//query enter, uri=content://FoodProviderT1Authority/search_suggest_query/%E6%9E%9C?limit=50, projection=null, selection=null, selectionArgs=null
		
		String query = null;
		if (uri.getPathSegments().size() > 1) {
			query = uri.getLastPathSegment().toLowerCase();
		}
		return getSuggestions(query);
	}

	private Cursor getSuggestions(String query) {
		String foodNamePart = query;
		DataAccess da = DataAccess.getSingleton(getContext());
		ArrayList<HashMap<String, Object>> foodLst = da.getFoodsByLikeCnName(foodNamePart);
		String[] COLUMNS = { "_id",
				SearchManager.SUGGEST_COLUMN_TEXT_1,
				SearchManager.SUGGEST_COLUMN_TEXT_2,
				SearchManager.SUGGEST_COLUMN_INTENT_DATA,
		};
		MatrixCursor cursor = new MatrixCursor(COLUMNS);
		if (foodLst != null){
			long id = 0;
			for (int i=0; i<foodLst.size(); i++) {
				HashMap<String, Object> food = foodLst.get(i);
				Object[] colVals = new Object[]{id,food.get(Constants.COLUMN_NAME_CnCaption), food.get(Constants.COLUMN_NAME_CnType), food.get(Constants.COLUMN_NAME_NDB_No)};
				cursor.addRow(colVals);
			}
		}
		return cursor;
	}


	@Override
	public int update(Uri uri, ContentValues values, String selection,
			String[] selectionArgs) {
		return 0;
	}
}
