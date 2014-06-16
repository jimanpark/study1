package Util;

import java.sql.Timestamp;
import java.text.ParseException;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

import org.apache.commons.lang.time.FastDateFormat;

import com.supinan.util.text.SupinanDateFormat;

public class DateUtil {
	public static Date parseDate(String toStr) {
		Date date = null;
		try {
		String[] parsePattern = {"yyyy-MM-dd HH:mm:ss Z"};
		date = org.apache.commons.lang.time.DateUtils.parseDate(toStr, parsePattern);
		} catch (ParseException e) {
		e.printStackTrace();
		}
		return date;
	}

	public static String formatDateTimeToString(String toDate) {
		if(!toDate.equals("")){
			Date date = parseDate(toDate);
			FastDateFormat format = FastDateFormat.getInstance("yyyy-MM-dd HH:mm", TimeZone.getDefault(), Locale.getDefault());
			return format.format(date);
		}else{
		return "";
		}
	}
	
	public static String formatDateTimeToString(Timestamp ts ,String pattern) {
		//pattern = yyyy-MM-dd HH:mm:ss
		//FastDateFormat format = FastDateFormat.getInstance(pattern, TimeZone.getDefault(), Locale.getDefault());
		SupinanDateFormat format = SupinanDateFormat.getInstance(pattern);
		return format.format(ts);
	}

}
