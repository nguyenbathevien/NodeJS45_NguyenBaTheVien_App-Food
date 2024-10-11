CREATE TABLE  `user` (
	user_id INT PRIMARY KEY AUTO_INCREMENT,
	full_name VARCHAR(255),
	email VARCHAR(255),
	password VARCHAR(255)
)

CREATE TABLE restaurant(
	res_id INT PRIMARY KEY AUTO_INCREMENT,
	res_name VARCHAR(255),
	image VARCHAR(255),
	`desc` VARCHAR(255)
)

CREATE TABLE rate_res(
	user_id INT,
	res_id INT,
	amount INT,
	date_rate DATETIME,
	FOREIGN KEY (user_id) REFERENCES `user`(user_id),
	FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
)

CREATE TABLE like_res(
	user_id INT,
	res_id INT,
	date_like DATETIME,
	FOREIGN KEY (user_id) REFERENCES `user`(user_id),
	FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
)



CREATE TABLE `type`(
	type_id INT PRIMARY KEY AUTO_INCREMENT,
	type_name VARCHAR(255)
)


CREATE TABLE food(
	food_id INT PRIMARY KEY AUTO_INCREMENT,
	food_name VARCHAR(255),
	image VARCHAR(255),
	price FLOAT,
	`desc` VARCHAR(255),
	type_id INT,
	FOREIGN KEY (type_id) REFERENCES `type`(type_id)
)


CREATE TABLE `order`(
	user_id INT,
	food_id INT,
	amount VARCHAR(255),
	code VARCHAR(255),
	arr_sub_id VARCHAR(255),
	FOREIGN KEY (user_id) REFERENCES `user`(user_id),
    FOREIGN KEY (food_id) REFERENCES food(food_id)
)

CREATE TABLE sub_food(
	sub_id INT PRIMARY KEY AUTO_INCREMENT,
	sub_name VARCHAR(255),
	sub_price FLOAT,
	food_id INT,
	FOREIGN KEY (food_id) REFERENCES food(food_id)
)


--Câu 1: Tìm 5 người đã like nhà hàng nhiều nhất
SELECT `user`.user_id,`user`.full_name, Count(like_res.user_id) as "Số lượt like"
FROM like_res
INNER JOIN `user` ON like_res.user_id = `user`.user_id
GROUP BY like_res.user_id
ORDER BY `Số lượt like` desc
LIMIT 5;

--Câu 2: Tìm 2 nhà hàng có lượt like nhiều nhất.
SELECT restaurant.res_id,restaurant.res_name, Count(like_res.res_id) as "Số lượt like"
FROM like_res
INNER JOIN restaurant ON like_res.res_id = restaurant.res_id
GROUP BY like_res.res_id
ORDER BY `Số lượt like` desc
LIMIT 2;

--Câu 3: Tìm người đã đặt hàng nhiều nhất
SELECT `order`.user_id, `user`.full_name,  SUM(`order`.amount) AS "Số lượng hàng đã đặt"
FROM `order`
INNER JOIN `user` ON `order`.user_id = `user`.user_id
GROUP BY `order`.user_id
ORDER BY `Số lượng hàng đã đặt` DESC
LIMIT 1;

--Câu 4: Tìm người dùng không hoạt động trong hệ thống (không đặt hàng, không like, không đánh giá nhà hàng).

SELECT *
FROM `user`
LEFT JOIN `order` on `order`.user_id = `user`.user_id
LEFT JOIN like_res on like_res.user_id = `user`.user_id
LEFT JOIN rate_res on rate_res.user_id = `user`.user_id
WHERE 
`order`.user_id is NULL AND
like_res.user_id is NULL AND
rate_res.user_id is NULL
