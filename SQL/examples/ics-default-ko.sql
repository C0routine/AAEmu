-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.12 - MySQL Community Server - GPL
-- Server OS:                    Linux
-- HeidiSQL Version:             12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

/*
루루의 상점에서 등록할 탭 위치 및 정렬 위치 값 설정
[main_tab] 메인 탭으로 아래와 같은 이름으로 분류됨.
메인(id: 1), 게임플레이(id: 2), 운송수단(id: 3), 하우징(id: 4), 외형(id: 5), 루루딱지(id: 6)

[sub_tab] 서브 탭으로 메인 탭별로 아래와 같은 이름으로 분류됨.
메인 [한정판매(id: 1), 추천(id: 2), 신규(id: 3), 전체(id: 4), sub_menu_1_5(id: 5), sub_menu_1_6(id: 6), sub_menu_1_7(id: 7)]
게임플레이 [전체(id: 1), 소비(id: 2), 편의(id: 3), 캐릭터(id: 4), sub_menu_2_5(id: 5), sub_menu_2_6(id: 6), 기타(id: 7)]
운송수단 [전체(id: 1), 날틀(id: 2), 소환수(id: 3), sub_menu_3_4(id: 4), sub_menu_3_5(id: 5), sub_menu_3_6(id: 6), sub_menu_3_7(id: 7)]
하우징 [전체(id: 1), 소유지(id: 2), 가구(id: 3), sub_menu_4_4(id: 4), sub_menu_4_5(id: 5), sub_menu_4_6(id: 6), 기타(id: 7)]
외형 [전체(id: 1), 소비(id: 2), 코스튬(id: 3), UCC아이템(id: 4), sub_menu_5_5(id: 5), sub_menu_5_6(id: 6), sub_menu_5_7(id: 7)]
루루딱지 [전체(id: 1), 아이템(id: 2), 소비(id: 3), 외형(id: 4), 펫(id: 5), sub_menu_6_6(id: 6), 기타(id: 7)]

[tab_pos] 각 속한 탭에서 순서 값

[shop_id] 상품 묶음 유니크 값
*/

-- Dumping structure for table aaemu_game.ics_menu
DROP TABLE IF EXISTS `ics_menu`;
CREATE TABLE IF NOT EXISTS `ics_menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `main_tab` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT 'Which main tab to display on',
  `sub_tab` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT 'Which sub tab to display on',
  `tab_pos` int(11) NOT NULL DEFAULT '0' COMMENT 'Used to change display order',
  `shop_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Id of the item group for sale (shop item)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Contains what item will be displayed on which tab';

-- Dumping data for table aaemu_game.ics_menu: ~2 rows (approximately)
REPLACE INTO `ics_menu` (`id`, `main_tab`, `sub_tab`, `tab_pos`, `shop_id`) VALUES
	(1, 1, 2, 1, 2000000), -- 황홀한 여명(노동력: 1000, 거래가능)
	(2, 1, 2, 2, 2000001), -- 신기루 금화교환권#11(상점 판매가 개당 42골드, 거래불가)
	(3, 1, 2, 3, 2000002), -- 빛나는 무기 강화 주문서(거래가능)
	(4, 1, 2, 4, 2000003), -- 빛나는 방어구 강화 주문서(거래가능)
	(5, 1, 2, 5, 2000004); -- 빛나는 장신구 강화 주문서(거래가능)

-- Dumping structure for table aaemu_game.ics_shop_items
DROP TABLE IF EXISTS `ics_shop_items`;
CREATE TABLE IF NOT EXISTS `ics_shop_items` (
  `shop_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'SKU item id',
  `display_item_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Item who''s icon to use for displaying in the shop, leave 0 for first item in the group',
  `name` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT 'Can be used to override the name in the shop',
  `limited_type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Enables limited stock mode if non-zero, Account(1), Chracter(2)',
  `limited_stock_max` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Number of items left in stock for this SKU if limited stock is enabled',
  `level_min` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Minimum level to buy the item (does not show on UI)',
  `level_max` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Maximum level to buy the item (does not show on UI)',
  `buy_restrict_type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Buy restriction rule, none (0), level (1) or quest(2)',
  `buy_restrict_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Level or QuestId for restrict rule',
  `is_sale` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `is_hidden` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `sale_start` datetime DEFAULT NULL COMMENT 'Limited sale start time',
  `sale_end` datetime DEFAULT NULL COMMENT 'Limited sale end time',
  `shop_buttons` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'All (0), NoCart (1), NoGift (2), OnlyBuy (3)',
  `remaining` int(11) NOT NULL DEFAULT '-1' COMMENT 'Number of items remaining, only for tab 1-1 (limited)',
  PRIMARY KEY (`shop_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2000005 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Possible Item listings that are for sale';

-- Dumping data for table aaemu_game.ics_shop_items: ~2 rows (approximately)
REPLACE INTO `ics_shop_items` (`shop_id`, `display_item_id`, `name`, `limited_type`, `limited_stock_max`, `level_min`, `level_max`, `buy_restrict_type`, `buy_restrict_id`, `is_sale`, `is_hidden`, `sale_start`, `sale_end`, `shop_buttons`, `remaining`) VALUES
	(2000000, 0, '황홀한 여명', 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, 0, -1), -- 황홀한 여명(노동력: 1000, 거래가능)
	(2000001, 0, '금화교환권', 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, 0, -1), -- 신기루 금화교환권#11(상점 판매가 개당 42골드, 거래불가)
	(2000002, 0, '빛나는 무기 강화 주문서', 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, 0, -1), -- 빛나는 무기 강화 주문서(거래가능)
	(2000003, 0, '빛나는 방어구 강화 주문서', 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, 0, -1), -- 빛나는 방어구 강화 주문서(거래가능)
	(2000004, 0, '빛나는 장신구 강화 주문서', 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, 0, -1); -- 빛나는 장신구 강화 주문서(거래가능)

-- Dumping structure for table aaemu_game.ics_skus
DROP TABLE IF EXISTS `ics_skus`;
CREATE TABLE IF NOT EXISTS `ics_skus` (
  `sku` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `shop_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Reference to the shop item',
  `position` int(10) NOT NULL DEFAULT '0' COMMENT 'Used for display order inside the item details',
  `item_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Item that is for sale',
  `item_count` int(10) unsigned NOT NULL DEFAULT '1' COMMENT 'Number of items for this detail',
  `select_type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `is_default` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Is this the default selection?',
  `event_type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `event_end_date` datetime DEFAULT NULL,
  `currency` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Credits(0), AAPoints(1), Loyalty(2), Coins(3)',
  `price` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Price of the item',
  `discount_price` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Discounted price (this is used if set)',
  `bonus_item_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Bonus item included for this purchase',
  `bonus_item_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Amount of bonus items included',
  PRIMARY KEY (`sku`)
) ENGINE=InnoDB AUTO_INCREMENT=1000005 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Has the actual sales items for the details';

-- Dumping data for table aaemu_game.ics_skus: ~2 rows (approximately)
REPLACE INTO `ics_skus` (`sku`, `shop_id`, `position`, `item_id`, `item_count`, `select_type`, `is_default`, `event_type`, `event_end_date`, `currency`, `price`, `discount_price`, `bonus_item_id`, `bonus_item_count`) VALUES
	(1000000, 2000000, 0, 31145, 100, 0, 0, 0, NULL, 0, 0, 0, 0, 0), -- 황홀한 여명(노동력: 1000, 거래가능)
	(1000001, 2000001, 0, 31739, 1000, 0, 0, 0, NULL, 0, 0, 0, 0, 0), -- 신기루 금화교환권#11(상점 판매가 개당 42골드, 거래불가)
	(1000002, 2000002, 0, 28296, 100, 0, 0, 0, NULL, 0, 0, 0, 0, 0), -- 빛나는 무기 강화 주문서(거래가능)
	(1000003, 2000003, 0, 28297, 100, 0, 0, 0, NULL, 0, 0, 0, 0, 0), -- 빛나는 방어구 강화 주문서(거래가능)
	(1000004, 2000004, 0, 31927, 100, 0, 0, 0, NULL, 0, 0, 0, 0, 0); -- 빛나는 장신구 강화 주문서(거래가능)


/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
