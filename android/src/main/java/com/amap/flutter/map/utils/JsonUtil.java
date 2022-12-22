package com.amap.flutter.map.utils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import androidx.annotation.NonNull;
import android.text.TextUtils;


import com.amap.flutter.map.utils.LogUtil;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.util.Iterator;
public class JsonUtil {

    /** * @param content json字符串 * @return 如果转换失败返回null, */
    public static Map<String, Object> jsonToMap(String content) {

        content = content.trim();
        Map<String, Object> result = new HashMap<>();
        try {

            if (content.charAt(0) == '[') {

                JSONArray jsonArray = new JSONArray(content);
                for (int i = 0; i < jsonArray.length(); i++) {

                    Object value = jsonArray.get(i);
                    if (value instanceof JSONArray || value instanceof JSONObject) {

                        result.put(i + "", jsonToMap(value.toString().trim()));
                    } else {

                        result.put(i + "", jsonArray.getString(i));
                    }
                }
            } else if (content.charAt(0) == '{'){

                JSONObject jsonObject = new JSONObject(content);
                Iterator<String> iterator = jsonObject.keys();
                while (iterator.hasNext()) {

                    String key = iterator.next();
                    Object value = jsonObject.get(key);
                    if (value instanceof JSONArray || value instanceof JSONObject) {

                        result.put(key, jsonToMap(value.toString().trim()));
                    } else {

                        result.put(key, value.toString().trim());
                    }
                }
            }else {
                LogUtil.i("jsonToMap", "jsonToMap: 字符串格式错误");
//                Log.e("异常", "json2Map: 字符串格式错误");
            }
        } catch (JSONException e) {
            LogUtil.i("jsonToMap", "jsonToMap: 异常" + e);
//            Log.e("异常", "json2Map: ", e);
            result = null;
        }
        return result;
    }
//    /**
//     * 将json字符串转化为map
//     *
//     * @param jsonStr json字符串
//     */
//    public static Map<String, Object> jsonToMap(@NonNull String jsonStr) throws JSONException {
//        if (TextUtils.isEmpty(jsonStr)) {
//            return null;
//        }
//        return jsonToMap(new JSONObject(jsonStr));
//    }
//
//    /**
//     * 将json对象转化为map
//     *
//     * @param json json对象
//     */
//    public static Map<String, Object> jsonToMap(JSONObject json) throws JSONException {
//        Map<String, Object> retMap = new HashMap<>();
//        if (json != JSONObject.NULL) {
//            retMap = toMap(json);
//        }
//        return retMap;
//    }
//
//    private static Map<String, Object> toMap(JSONObject object) throws JSONException {
//        Map<String, Object> map = new HashMap<>();
//
//        Iterator<String> keysItr = object.keys();
//        while (keysItr.hasNext()) {
//            String key = keysItr.next();
//            Object value = object.get(key);
//            if (value instanceof JSONArray) {
//                value = toList((JSONArray) value);
//            } else if (value instanceof JSONObject) {
//                value = toMap((JSONObject) value);
//            }
//            map.put(key, value);
//        }
//        return map;
//    }
//
//    private static List<Object> toList(JSONArray array) throws JSONException {
//        List<Object> list = new ArrayList<>();
//        for (int i = 0; i < array.length(); i++) {
//            Object value = array.get(i);
//            if (value instanceof JSONArray) {
//                value = toList((JSONArray) value);
//            } else if (value instanceof JSONObject) {
//                value = toMap((JSONObject) value);
//            }
//            list.add(value);
//        }
//        return list;
//    }
}