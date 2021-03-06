--4-1
--DECLARE
--    CURSOR cur_basket IS
--        SELECT bi.idBasket, bi.quantity, p.stock
--        FROM bb_basketitem bi INNER JOIN bb_product p
--        USING (idProduct)
--        WHERE bi.idBasket = 6;
--    TYPE type_basket IS RECORD (
--        basket bb_basketitem.idBasket%TYPE,
--        qty bb_basketitem.quantity%TYPE,
--        stock bb_product.stock%TYPE);
--    rec_basket type_basket;
--    lv_flag_txt CHAR(1) := 'Y';
--BEGIN
--    OPEN cur_basket;
--    LOOP
--    FETCH cur_basket INTO rec_basket;
--    EXIT WHEN cur_basket%NOTFOUND;
--        IF rec_basket.stock < rec_basket.qty THEN lv_flag_txt := 'N';
--        END IF;
--    END LOOP;
--    CLOSE cur_basket;
--    IF lv_flag_txt = 'Y' THEN DBMS_OUTPUT.PUT_LINE('All items in stock!'); 
--    END IF;
--    IF lv_flag_txt = 'N' THEN DBMS_OUTPUT.PUT_LINE('All items NOT in 
--        stock!'); 
--    END IF;
--END;
--4-2
--DECLARE
--    CURSOR cur_shopper IS
--        SELECT a.idShopper, a.promo,  b.total
--        FROM bb_shopper a, (SELECT b.idShopper, SUM(bi.quantity*bi.price) total
--            FROM bb_basketitem bi, bb_basket b
--            WHERE bi.idBasket = b.idBasket
--            GROUP BY idShopper) b
--        WHERE a.idShopper = b.idShopper
--    FOR UPDATE OF a.idShopper NOWAIT;
--    lv_promo_txt CHAR(1);
--BEGIN
--    FOR rec_shopper IN cur_shopper 
--    LOOP
--    lv_promo_txt := 'X';
--    IF rec_shopper.total > 100 THEN
--    lv_promo_txt := 'A';
--    END IF;
--    IF rec_shopper.total BETWEEN 50 AND 99 THEN
--    lv_promo_txt := 'B';
--    END IF;
--    IF lv_promo_txt <> 'X' THEN
--    UPDATE bb_shopper
--        SET promo = lv_promo_txt
--        WHERE CURRENT OF cur_shopper;
--    END IF;
--    END LOOP;
--COMMIT;
--END;
--4-3
--UPDATE bb_shopper
--SET promo = NULL;
--UPDATE bb_shopper
--SET promo = 'B'
--WHERE idShopper IN (21,23,25);
--UPDATE bb_shopper
--SET promo = 'A'
--WHERE idShopper = 22;
--COMMIT;
--BEGIN
--    UPDATE bb_shopper
--    SET promo = NULL
--    WHERE promo IS NOT NULL;
--    IF SQL%ROWCOUNT > 0 THEN
--        DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT||' rows updated'); --shows how many SQL rows are updated
--    ELSE
--        DBMS_OUTPUT.PUT_LINE('No rows changed');
--    END IF;
--END;
--4-4
--DECLARE
--    lv_tax_num NUMBER(2,2);
--    no_tax EXCEPTION;
--    PRAGMA EXCEPTION_INIT (no_tax,-06592);
--BEGIN
--    CASE  'NJ'
--    WHEN 'VA' THEN lv_tax_num := .04;
--    WHEN 'NC' THEN lv_tax_num := .02;
--    WHEN 'NY' THEN lv_tax_num := .06;
--    END CASE;
--    DBMS_OUTPUT.PUT_LINE('tax rate = '||lv_tax_num);
--    EXCEPTION
--        WHEN no_tax THEN
--            DBMS_OUTPUT.PUT_LINE('No Tax!');
--END;
--4-5
DECLARE
    rec_shopper bb_shopper%ROWTYPE;
BEGIN
    SELECT * INTO rec_shopper FROM bb_shopper
        WHERE idShopper = 99;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('User ID Does Not Exist');
END;