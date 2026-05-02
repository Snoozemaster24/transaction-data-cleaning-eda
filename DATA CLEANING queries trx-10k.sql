-- 1. Standardize card types

UPDATE dirty_iranian_transactions_dataset.`trx-10k`
SET card_type = 'MasterCard'
WHERE card_type IN ('MastCard', 'Master card');
                    
                    
UPDATE dirty_iranian_transactions_dataset.`trx-10k`
SET card_type = 'Visa'
WHERE card_type = 'Vsa';



-- 2. Spliting datetime to two individual column.   

ALTER TABLE dirty_iranian_transactions_dataset.`trx-10k`
ADD COLUMN date VARCHAR (50)
AFTER time;


ALTER TABLE dirty_iranian_transactions_dataset.`trx-10k`
ADD COLUMN time_ VARCHAR (50)
AFTER date;


UPDATE dirty_iranian_transactions_dataset.`trx-10k`
SET time_ = SUBSTRING_INDEX(time,' ' ,-1);

UPDATE dirty_iranian_transactions_dataset.`trx-10k`
SET date = SUBSTRING_INDEX(time,' ' , 1);

ALTER TABLE dirty_iranian_transactions_dataset.`trx-10k`
DROP COLUMN time;

ALTER TABLE dirty_iranian_transactions_dataset.`trx-10k` RENAME COLUMN time_ to time
;


-- 3. Standardizing status

 UPDATE dirty_iranian_transactions_dataset.`trx-10k`
SET status = 'Success'
WHERE status =  'succeed' ;

 UPDATE dirty_iranian_transactions_dataset.`trx-10k`
SET status = 'failed'
WHERE status = 'fail' ;

UPDATE dirty_iranian_transactions_dataset.`trx-10k`
SET status = LOWER(status);


-- 4. Cleaning city column

UPDATE dirty_iranian_transactions_dataset.`trx-10k`
SET city = 'Tehran'
WHERE city = '%tehr%';
                                                            
UPDATE dirty_iranian_transactions_dataset.`trx-10k`
SET city = 'Tehran'
WHERE city LIKE '%thr%';
                    
UPDATE dirty_iranian_transactions_dataset.`trx-10k`
SET city = 'Karaj'
WHERE city = 'karaj';
                    
                    
  -- 5. Handling amount (zeros & negatives)          
  
 UPDATE dirty_iranian_transactions_dataset.`trx-10k`
SET amount  =  NULL
WHERE amount = 0;

UPDATE dirty_iranian_transactions_dataset.`trx-10k`
SET amount = null
WHERE  amount < 0;


