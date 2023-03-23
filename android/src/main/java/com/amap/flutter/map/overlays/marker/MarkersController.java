package com.amap.flutter.map.overlays.marker;

import android.content.Context;
import android.graphics.Bitmap;
import android.location.Location;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;

import com.amap.api.maps.AMap;
import com.amap.api.maps.CameraUpdateFactory;
import com.amap.api.maps.TextureMapView;
import com.amap.api.maps.model.BitmapDescriptor;
import com.amap.api.maps.model.BitmapDescriptorFactory;
import com.amap.api.maps.model.LatLng;
import com.amap.api.maps.model.LatLngBounds;
import com.amap.api.maps.model.LatLngCreator;
import com.amap.api.maps.model.Marker;
import com.amap.api.maps.model.MarkerOptions;
import com.amap.api.maps.model.Poi;
import com.amap.api.maps.model.Polyline;
import com.amap.flutter.amap_flutter_map.R;
import com.amap.flutter.map.MyMethodCallHandler;
import com.amap.flutter.map.overlays.AbstractOverlayController;
import com.amap.flutter.map.utils.Const;
import com.amap.flutter.map.utils.ConvertUtil;
import com.amap.flutter.map.utils.LogUtil;
import com.amap.flutter.map.utils.JsonUtil;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;



import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;



/**
 * @author whm
 * @date 2020/11/6 5:38 PM
 * @mail hongming.whm@alibaba-inc.com
 * @since
 */
public class MarkersController
        extends AbstractOverlayController<MarkerController>
        implements MyMethodCallHandler,
        AMap.OnMapClickListener,
        AMap.OnMarkerClickListener,
        AMap.OnMarkerDragListener,
        AMap.OnPOIClickListener {
    private static final String CLASS_NAME = "MarkersController";
    private String selectedMarkerDartId;
    private Context mContext;

    public MarkersController(MethodChannel methodChannel, AMap amap, Context context) {
        super(methodChannel, amap);
        this.mContext = context;
        amap.addOnMarkerClickListener(this);
        amap.addOnMarkerDragListener(this);
        amap.addOnMapClickListener(this);
        amap.addOnPOIClickListener(this);
    }

    @Override
    public String[] getRegisterMethodIdArray() {
        return Const.METHOD_ID_LIST_FOR_MARKER;
    }


    @Override
    public void doMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        LogUtil.i(CLASS_NAME, "doMethodCall===>" + call.method);
        switch (call.method) {
            case Const.METHOD_MARKER_UPDATE:
                invokeMarkerOptions(call, result);
                break;
        }
    }

    /**
     * 执行主动方法更新marker
     *
     * @param methodCall
     * @param result
     */
    public void invokeMarkerOptions(MethodCall methodCall, MethodChannel.Result result) {
        if (null == methodCall) {
            return;
        }
        Object markersToAdd = methodCall.argument("markersToAdd");
//        addByList((List<Object>) markersToAdd);
        myAddByList((List<Object>) markersToAdd);
        Object markersToChange = methodCall.argument("markersToChange");
        updateByList((List<Object>) markersToChange);
        Object markerIdsToRemove = methodCall.argument("markerIdsToRemove");
        removeByIdList((List<Object>) markerIdsToRemove);
        result.success(null);
    }


    //自定义标记点 markersToAdd是flutter传入的所有标记点数组，内含坐标数据，image图片，以及气泡显示文字
    public void myAddByList(List<Object> markersToAdd) {
        LogUtil.i(CLASS_NAME, "markersToAdd==>" + markersToAdd);
        if (markersToAdd != null && !markersToAdd.isEmpty()) {
            ArrayList<LatLng> posList = new ArrayList<>();
            for (Object flutterMarker : markersToAdd) {
                //单个添加：获取flutter中的标记点Id
                String flutterMarkerId = ConvertUtil.getKeyValueFromMapObject(flutterMarker, "id").toString();
                if (!TextUtils.isEmpty(flutterMarkerId)) {
                    ///经纬度
                    final Object positionObj = ConvertUtil.getKeyValueFromMapObject(flutterMarker, "position");
                    LatLng position = ConvertUtil.toLatLng(positionObj);
                    posList.add(position);

                    ///文字信息数据
                    Map<String, Object> infoWindow = (Map<String, Object>) ConvertUtil.getKeyValueFromMapObject(flutterMarker, "infoWindow");
                    //传输的数据
                    String jsonString = (String) infoWindow.get("title");
                    //type： 0换电地图 1充电地图
                    //num：type=0时，电池数量，type=1时，可用充电枪数量
                    //desc：type=0时，排队人数，type=1时，当前价格
                    //imageString：图片名称
                    Map infoData = JsonUtil.jsonToMap(jsonString);
                    //换电地图标记点样式
                    View view;
                    String type = (String) infoData.get("type");
                    int i =  Integer.parseInt(type);
                    String num = (String) infoData.get("num");
                    String desc = (String) infoData.get("desc");
                    String imageString = (String) infoData.get("imageString");
                    if (i == 0){
                        LogUtil.i(CLASS_NAME,"0000000000换电地图"+infoData);
                        view = View.inflate(this.mContext, R.layout.layout_hd_map, null);

                        ImageView iv_icon = view.findViewById(R.id.tv_hd_icon);
                        if (imageString.equals("dthdyy")){
                            iv_icon.setImageResource(R.mipmap.dthdyy);
                        }else if (imageString.equals("dthdty")){
                            iv_icon.setImageResource(R.mipmap.dthdty);
                        }else if (imageString.equals("dthdjsz")){
                            iv_icon.setImageResource(R.mipmap.dthdjsz);
                        }else if (imageString.equals("dthdwh")){
                            iv_icon.setImageResource(R.mipmap.dthdwh);
                        }else {
                            iv_icon.setImageResource(R.mipmap.dthdyy);
                        }
                        //排队人数
                        TextView tv_line = view.findViewById(R.id.tv_line);
                        tv_line.setText(desc);
                        //电池数量
                        TextView tv_power = view.findViewById(R.id.tv_power);
                        tv_power.setText(num);
                    }else {
                        LogUtil.i(CLASS_NAME,"1111111111充电地图"+infoData);
                        view = View.inflate(this.mContext, R.layout.layout_cd_map, null);
                        ImageView iv_icon = view.findViewById(R.id.tv_cd_icon);
                        if (imageString.equals("dtcdty")){
                            iv_icon.setImageResource(R.mipmap.dtcdty);
                        }else if (imageString.equals("dtcdyy")){
                            iv_icon.setImageResource(R.mipmap.dtcdyy);
                        }else if (imageString.equals("dtcdjsz")){
                            iv_icon.setImageResource(R.mipmap.dtcdjsz);
                        }else if (imageString.equals("dtcdwh")){
                            iv_icon.setImageResource(R.mipmap.dtcdwh);
                        }else {
                            iv_icon.setImageResource(R.mipmap.dtcdyy);
                        }
                        //充电价格
                        TextView tv_price = view.findViewById(R.id.tv_price);
                        tv_price.setText(desc);
                        LogUtil.i(CLASS_NAME,"1111111111充电价格"+desc);
                        //充电枪数量
                        TextView tv_num = view.findViewById(R.id.tv_num);
                        tv_num.setText(num);
                        LogUtil.i(CLASS_NAME,"1111111111充电枪"+num);
                    }
                    


                    //将自定义的view转化成bitmap添加到标记点上
                    BitmapDescriptor markerIcon = BitmapDescriptorFactory.fromView(view);
                    //初始化marker属性数据
                    MarkerOptions markerOptions = new MarkerOptions().position(position).draggable(false).icon(markerIcon).setFlat(true);
                    //单个添加：marker
                    Marker marker = amap.addMarker(markerOptions);
                    marker.setClickable(true);
                    marker.setInfoWindowEnable(false);//点击弹出气泡
                    //将flutter中的markerId与地图中的markerId绑定一起
                    MarkerController markerController = new MarkerController(marker);
                    controllerMapByDartId.put(flutterMarkerId, markerController);
                    idMapByOverlyId.put(marker.getId(), flutterMarkerId);
                }
            }
            //移动显示区域,包括自身定位点
            //  Location userLocation = amap.getMyLocation();
            //  if (userLocation != null){
            //    double userLat = userLocation.getLatitude();
            //    double userLng = userLocation.getLongitude();
            //    LatLng user = new LatLng(userLat,userLng);
            //    posList.add(user);
            //  }
            // LogUtil.i(CLASS_NAME, "posList==>" + posList + userLocation);
            zoomToSpan(posList);
        }
    }


//    //view 转bitmap
//    private static Bitmap convertViewToBitmap(View view) {
//        view.measure(View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED), View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED));
//        view.layout(0, 0, view.getMeasuredWidth(), view.getMeasuredHeight());
//        view.buildDrawingCache();
//        Bitmap bitmap = view.getDrawingCache();
//        return bitmap;
//    }
    //移动地图至所有标记点显示区域
    public void zoomToSpan(ArrayList<LatLng> mPois) {
        if (mPois != null && mPois.size() > 0) {
            if (amap == null)
                return;
            LatLngBounds bounds = getLatLngBounds(mPois);
            //四周边距200px = 100dp
            amap.moveCamera(CameraUpdateFactory.newLatLngBounds(bounds, 200));
        }
    }

    private LatLngBounds getLatLngBounds(ArrayList<LatLng> mPois) {
        LatLngBounds.Builder b = LatLngBounds.builder();
        for (int i = 0; i < mPois.size(); i++) {
            b.include(new LatLng(mPois.get(i).latitude,
                    mPois.get(i).longitude));
        }
        return b.build();
    }

    //markersToAdd是flutter传入的所有标记点数组，内含坐标数据，image图片，以及气泡显示文字
    public void addByList(List<Object> markersToAdd) {
        if (markersToAdd != null) {
            for (Object markerToAdd : markersToAdd) {
                add(markerToAdd);
            }
        }
    }

    //markerObj内含坐标数据，image图片，以及气泡显示文字
    private void add(Object markerObj) {
        if (null != amap) {
            MarkerOptionsBuilder builder = new MarkerOptionsBuilder();
            String dartMarkerId = MarkerUtil.interpretMarkerOptions(markerObj, builder);
            if (!TextUtils.isEmpty(dartMarkerId)) {

                MarkerOptions markerOptions = builder.build();
                final Marker marker = amap.addMarker(markerOptions);
                Object clickable = ConvertUtil.getKeyValueFromMapObject(markerObj, "clickable");
                if (null != clickable) {
                    marker.setClickable(ConvertUtil.toBoolean(clickable));
                }
                MarkerController markerController = new MarkerController(marker);
                controllerMapByDartId.put(dartMarkerId, markerController);
                idMapByOverlyId.put(marker.getId(), dartMarkerId);
            }
        }
    }

    private void updateByList(List<Object> markersToChange) {
        if (markersToChange != null) {
            for (Object markerToChange : markersToChange) {
                update(markerToChange);
            }
        }
    }

    private void update(Object markerToChange) {
        Object dartMarkerId = ConvertUtil.getKeyValueFromMapObject(markerToChange, "id");
        if (null != dartMarkerId) {
            MarkerController markerController = controllerMapByDartId.get(dartMarkerId);
            if (null != markerController) {
                MarkerUtil.interpretMarkerOptions(markerToChange, markerController);
            }
        }
    }


    private void removeByIdList(List<Object> markerIdsToRemove) {
        if (markerIdsToRemove == null) {
            return;
        }
        for (Object rawMarkerId : markerIdsToRemove) {
            if (rawMarkerId == null) {
                continue;
            }
            String markerId = (String) rawMarkerId;
            final MarkerController markerController = controllerMapByDartId.remove(markerId);
            if (markerController != null) {

                idMapByOverlyId.remove(markerController.getMarkerId());
                markerController.remove();
            }
        }
    }

    private void showMarkerInfoWindow(String dartMarkId) {
        MarkerController markerController = controllerMapByDartId.get(dartMarkId);
        if (null != markerController) {
            markerController.showInfoWindow();
        }
    }

    private void hideMarkerInfoWindow(String dartMarkId, LatLng newPosition) {
        if (TextUtils.isEmpty(dartMarkId)) {
            return;
        }
        if (!controllerMapByDartId.containsKey(dartMarkId)) {
            return;
        }
        MarkerController markerController = controllerMapByDartId.get(dartMarkId);
        if (null != markerController) {
            if (null != newPosition && null != markerController.getPosition()) {
                if (markerController.getPosition().equals(newPosition)) {
                    return;
                }
            }
            markerController.hideInfoWindow();
        }
    }

    @Override
    public void onMapClick(LatLng latLng) {
        hideMarkerInfoWindow(selectedMarkerDartId, null);
    }

    @Override
    public boolean onMarkerClick(Marker marker) {
        String dartId = idMapByOverlyId.get(marker.getId());
        if (null == dartId) {
            return false;
        }
        final Map<String, Object> data = new HashMap<>(1);
        data.put("markerId", dartId);
        selectedMarkerDartId = dartId;
        showMarkerInfoWindow(dartId);
        methodChannel.invokeMethod("marker#onTap", data);
        LogUtil.i(CLASS_NAME, "onMarkerClick==>" + data);
        return true;
    }

    @Override
    public void onMarkerDragStart(Marker marker) {

    }

    @Override
    public void onMarkerDrag(Marker marker) {

    }

    @Override
    public void onMarkerDragEnd(Marker marker) {
        String markerId = marker.getId();
        String dartId = idMapByOverlyId.get(markerId);
        LatLng latLng = marker.getPosition();
        if (null == dartId) {
            return;
        }
        final Map<String, Object> data = new HashMap<>(2);
        data.put("markerId", dartId);
        data.put("position", ConvertUtil.latLngToList(latLng));
        methodChannel.invokeMethod("marker#onDragEnd", data);

        LogUtil.i(CLASS_NAME, "onMarkerDragEnd==>" + data);
    }

    @Override
    public void onPOIClick(Poi poi) {
        hideMarkerInfoWindow(selectedMarkerDartId, null != poi ? poi.getCoordinate() : null);
    }

}
