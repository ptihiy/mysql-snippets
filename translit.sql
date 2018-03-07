/* Based on http://www.sql.ru/forum/actualutils.aspx?action=gotomsg&tid=1090122&msg=21124717 */

DROP FUNCTION IF EXISTS TRANSLIT;

/* Necessary because the semicolon is used within function */
DELIMITER //

FUNCTION TRANSLIT(str TEXT CHARSET utf8)
RETURNS text CHARSET utf8

/* Characteristic */
DETERMINISTIC
SQL SECURITY INVOKER

/* Body */
BEGIN
  DECLARE loweredStr  TEXT CHARSET utf8;
  DECLARE charAt      VARCHAR(3) CHARSET utf8;
  DECLARE subAt       VARCHAR(3) CHARSET utf8;
  DECLARE prevSubAt   VARCHAR(3) CHARSET utf8;
  DECLARE resultStr   TEXT CHARSET utf8;
  DECLARE strLength   INT(11);
  DECLARE i           INT(11);
  DECLARE offset      INT(11);
  DECLARE alphabet    VARCHAR(37) CHARSET utf8;

  SET i =             0;
  SET resultStr =     '';
  SET loweredStr =    LOWER(str);
  SET strLength =     CHAR_LENGTH(str);
  SET alphabeth =     ' .абвгдеёжзийклмнопрстуфхцчшщъыьэюя';

  WHILE i < strLength DO

    SET i = i + 1;
    SET charAt = SUBSTRING(loweredStr, i, 1);
    SET offset = INSTR(alphabet, charAt);

    IF charAt >= '0' AND charAt <= '9' OR charAt >= 'a' AND charAt <= 'z' OR charAt = '-' THEN
      SET subAt = charAt;
    ELSE
      SET subAt = ELT(offset, '-', '-',
                  'a','b','v','g', 'd', 'e', 'yo','zh', 'z',
                  'i','j','k','l', 'm', 'n', 'o', 'p', 'r',
                  's','t','u','f', 'h', 'c','ch','sh','sch',
                  '', 'y', '','e','yu','ya');

    END IF;

    IF subAt IS NOT NULL AND NOT(subAt = '-' AND prevSubAt = '-') THEN
      SET resultStr = CONCAT(resultStr, subAt);
    END IF;

    SET prevSubAt = subAt;

  END WHILE;

  RETURN resultStr;
END //

DELIMITER ;