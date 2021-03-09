/*
 Navicat Premium Data Transfer

 Source Server         : local
 Source Server Type    : MySQL
 Source Server Version : 80013
 Source Host           : localhost:3306
 Source Schema         : seata_order

 Target Server Type    : MySQL
 Target Server Version : 80013
 File Encoding         : 65001

 Date: 07/06/2020 23:07:56
*/
CREATE database if NOT EXISTS `seata_order` default character set utf8mb4 collate utf8mb4_unicode_ci;
use `seata_order`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- -------------------------------- The script used when storeMode is 'db' --------------------------------
-- the table to store GlobalSession data
CREATE TABLE IF NOT EXISTS `global_table`
(
    `xid`                       VARCHAR(128) NOT NULL,
    `transaction_id`            BIGINT,
    `status`                    TINYINT      NOT NULL,
    `application_id`            VARCHAR(32),
    `transaction_service_group` VARCHAR(32),
    `transaction_name`          VARCHAR(128),
    `timeout`                   INT,
    `begin_time`                BIGINT,
    `application_data`          VARCHAR(2000),
    `gmt_create`                DATETIME,
    `gmt_modified`              DATETIME,
    PRIMARY KEY (`xid`),
    KEY `idx_gmt_modified_status` (`gmt_modified`, `status`),
    KEY `idx_transaction_id` (`transaction_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

-- the table to store BranchSession data
CREATE TABLE IF NOT EXISTS `branch_table`
(
    `branch_id`         BIGINT       NOT NULL,
    `xid`               VARCHAR(128) NOT NULL,
    `transaction_id`    BIGINT,
    `resource_group_id` VARCHAR(32),
    `resource_id`       VARCHAR(256),
    `branch_type`       VARCHAR(8),
    `status`            TINYINT,
    `client_id`         VARCHAR(64),
    `application_data`  VARCHAR(2000),
    `gmt_create`        DATETIME(6),
    `gmt_modified`      DATETIME(6),
    PRIMARY KEY (`branch_id`),
    KEY `idx_xid` (`xid`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

-- the table to store lock data
CREATE TABLE IF NOT EXISTS `lock_table`
(
    `row_key`        VARCHAR(128) NOT NULL,
    `xid`            VARCHAR(128),
    `transaction_id` BIGINT,
    `branch_id`      BIGINT       NOT NULL,
    `resource_id`    VARCHAR(256),
    `table_name`     VARCHAR(32),
    `pk`             VARCHAR(36),
    `gmt_create`     DATETIME,
    `gmt_modified`   DATETIME,
    PRIMARY KEY (`row_key`),
    KEY `idx_branch_id` (`branch_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

-- ----------------------------
-- Table structure for so_item
-- ----------------------------
DROP TABLE IF EXISTS `so_item`;
CREATE TABLE `so_item` (
  `sysno` bigint(20) NOT NULL AUTO_INCREMENT,
  `so_sysno` bigint(20) DEFAULT NULL,
  `product_sysno` bigint(20) DEFAULT NULL,
  `product_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '商品名称',
  `cost_price` decimal(16,6) DEFAULT NULL COMMENT '成本价',
  `original_price` decimal(16,6) DEFAULT NULL COMMENT '原价',
  `deal_price` decimal(16,6) DEFAULT NULL COMMENT '成交价',
  `quantity` int(11) DEFAULT NULL COMMENT '数量',
  PRIMARY KEY (`sysno`)
) ENGINE=InnoDB AUTO_INCREMENT=1269646673999564801 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单明细表';

-- ----------------------------
-- Table structure for so_master
-- ----------------------------
DROP TABLE IF EXISTS `so_master`;
CREATE TABLE `so_master` (
  `sysno` bigint(20) NOT NULL,
  `so_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `buyer_user_sysno` bigint(20) DEFAULT NULL COMMENT '下单用户号',
  `seller_company_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '卖家公司编号',
  `receive_division_sysno` bigint(20) NOT NULL,
  `receive_address` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `receive_zip` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `receive_contact` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `receive_contact_phone` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `stock_sysno` bigint(20) DEFAULT NULL,
  `payment_type` tinyint(4) DEFAULT NULL COMMENT '支付方式：1，支付宝，2，微信',
  `so_amt` decimal(16,6) DEFAULT NULL COMMENT '订单总额',
  `status` tinyint(4) DEFAULT NULL COMMENT '10,创建成功，待支付；30；支付成功，待发货；50；发货成功，待收货；70，确认收货，已完成；90，下单失败；100已作废',
  `order_date` timestamp NULL DEFAULT NULL COMMENT '下单时间',
  `paymemt_date` timestamp NULL DEFAULT NULL COMMENT '支付时间',
  `delivery_date` timestamp NULL DEFAULT NULL COMMENT '发货时间',
  `receive_date` timestamp NULL DEFAULT NULL COMMENT '发货时间',
  `appid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '订单来源',
  `memo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `create_user` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gmt_create` timestamp NULL DEFAULT NULL,
  `modify_user` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gmt_modified` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`sysno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单表';

-- for AT mode you must to init this sql for you business database. the seata server not need it.
CREATE TABLE IF NOT EXISTS `undo_log`
(
    `branch_id`     BIGINT       NOT NULL COMMENT 'branch transaction id',
    `xid`           VARCHAR(128) NOT NULL COMMENT 'global transaction id',
    `context`       VARCHAR(128) NOT NULL COMMENT 'undo_log context,such as serialization',
    `rollback_info` LONGBLOB     NOT NULL COMMENT 'rollback info',
    `log_status`    INT(11)      NOT NULL COMMENT '0:normal status,1:defense status',
    `log_created`   DATETIME(6)  NOT NULL COMMENT 'create datetime',
    `log_modified`  DATETIME(6)  NOT NULL COMMENT 'modify datetime',
    UNIQUE KEY `ux_undo_log` (`xid`, `branch_id`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8 COMMENT ='AT transaction mode undo table';

SET FOREIGN_KEY_CHECKS = 1;
