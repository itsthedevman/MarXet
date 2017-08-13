CREATE TABLE `marxet` (
  `listingID` varchar(8) NOT NULL,
  `itemAvailable` tinyint(1) NOT NULL DEFAULT '1',
  `itemArray` text NOT NULL,
  `price` double NOT NULL,
  `sellerUID` varchar(64) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`listingID`),
  KEY `listingID` (`listingID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
