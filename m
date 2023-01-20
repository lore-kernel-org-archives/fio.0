Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D47C8C25B4E
	for <fio@archiver.kernel.org>; Fri, 20 Jan 2023 15:54:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbjATPyx (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 20 Jan 2023 10:54:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbjATPyl (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 20 Jan 2023 10:54:41 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791AE5E526
        for <fio@vger.kernel.org>; Fri, 20 Jan 2023 07:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674230069; x=1705766069;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Qf+ocXF6lqrlemHdyp+b/h/KCHoMNKtHUl507YuvLVU=;
  b=JFGjDJ+lj7giUmNy0mpOsEXywYbu5miBD4Xl7QPfDcbKOTEqFvdCIvSp
   BhlE8G+6VFrs4IDAVI5mm0CKZtfMqg9rO/NYCDc8mhLZyUynZez3p4sXf
   dCWN7SDNkNnREnEVyeEP/lin53F2BdDrBkSrEc36vnvJoFw1i2prKktGp
   OM6MMb7mrxc/bKpUWmPcEL1z6wshMOLJ1/pncVzNrjDZUHk8mLKmBCb+h
   Y/bTyuauf/eHXWCLtkv8Nj53vCH0KnSSgb6/7clk+nYj34eIFhgJ1+fhR
   vw7R7Hpuw8Q/sb+qY7zFUuRLAh5oTvvfwThnMKbboCXnzISFA/a2JML5d
   A==;
X-IronPort-AV: E=Sophos;i="5.97,232,1669046400"; 
   d="scan'208";a="226377636"
Received: from mail-dm6nam11lp2171.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.171])
  by ob1.hgst.iphmx.com with ESMTP; 20 Jan 2023 23:54:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n2aa0dbajCcpaj4OvHK/EY8iKxqf+9m4l147KnBrhcCMU6+rJfj6iMycPBbQ1lAhcj4hwGudx63olS/Mvrx3ZVd5PsmsGjVUDazu/pIbLcQkPqunfJlSpTDtIBCcsyT3sionwVIDVd7WJcBaI6KALCyvsh04/kZ+n+49BmpMyJfc5EMUnbuiXcWIj88l/WwFjE04MJAQMbdfwlxTzROuVlW7G/9ZyRvthuAc6i6U+OggVvZOqLA7Ag8ssuonNrNjqe2PvoOmkHgDJO45dFgZYB7zysSwnW8VaZ4Jm2j9ZWwLPdEYVNf2q0V3VwetxxrN1qe1xYBb/QmqMEhsKEDcVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qf+ocXF6lqrlemHdyp+b/h/KCHoMNKtHUl507YuvLVU=;
 b=S+2svD2MNuubh/kRmLUrL6SuvopMDOsaxMU23PIo8Hz7kKeE2S0CvBVhJbUMFJtO/YawMkLM7tcYES60wfpCggVctwwQC4UdgzZQQnBEW6pDl+i/EJpoz1IrxQR8v3HkBuk+Fw9miWh8h0lbC7Adx51fM9cRcmIy+KzyxkvsutveCMi1OvErnIiAubbqA1+jRWxSqpvIipkFt2aptnqyd8QiuNt3ks/SVPyPy3Wf4VvimbYIF08Y9RT9GNXyL1aZ8s5nckk9l402MGK0v+ZclXWFVbU665X4eoDYT3QufLlGSkR4pXQiq7Nz/ZVVCnUbeZUv83aACwas4GqrCZtRlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qf+ocXF6lqrlemHdyp+b/h/KCHoMNKtHUl507YuvLVU=;
 b=ugudfKIiF2ZUZ6q4mk1qoz1RAoYYtEK1EF8gEqGysfTnIihwfk7mhSiTaTy5/dvidFfM5mA2HSeTo+lhchd5McOcJtLU7I4ALI6+mjy/GUMZzU8nKhKrM5eMmQ4QWQE3IT4RWz2/ixVMN2705mjxx9tE+DIjRjp2gmhoLfnU0Z4=
Received: from DM6PR04MB4491.namprd04.prod.outlook.com (2603:10b6:5:1f::30) by
 MWHPR04MB1263.namprd04.prod.outlook.com (2603:10b6:301:42::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.27; Fri, 20 Jan 2023 15:54:21 +0000
Received: from DM6PR04MB4491.namprd04.prod.outlook.com
 ([fe80::915:fcbe:3549:9d09]) by DM6PR04MB4491.namprd04.prod.outlook.com
 ([fe80::915:fcbe:3549:9d09%6]) with mapi id 15.20.6002.024; Fri, 20 Jan 2023
 15:54:21 +0000
From:   Boopalan M <Boopalan.M@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>,
        "vincentfu@gmail.com" <vincentfu@gmail.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: Re: FIO data validation profile
Thread-Topic: FIO data validation profile
Thread-Index: AQHZLNMJD5R7N9dtPU+r/swYg33XRa6ncueAgABekAA=
Date:   Fri, 20 Jan 2023 15:54:21 +0000
Message-ID: <264E43A0-99F5-401D-878D-6E93EDA81793@wdc.com>
References: <5250B9CE-B34C-4728-BADE-05506B387C24@wdc.com>
 <3575025c-717a-57c3-58dc-fd6e885d7f78@kernel.dk>
In-Reply-To: <3575025c-717a-57c3-58dc-fd6e885d7f78@kernel.dk>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.69.23010700
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB4491:EE_|MWHPR04MB1263:EE_
x-ms-office365-filtering-correlation-id: 86c1cacc-2374-48ba-2469-08dafafe98a9
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LydYf7VSFmTncrEjvqhppFCtRWEn0cUaLB2faj+BURRhy3OxGEzqgdE4wOt9kGlLB/Woy5bZKAZz9aC5u5fnMJDE3CcX+D6Xb3q3CycfdRFzSO7SmPHggqlFAte+kfIXHNQbjhbAD3f0hO4GjSCL52XDy0s+lH3bcR202nTsTmZ7ov2Aj9GlOtIYIMtTms1QRiKU9kT9pdxPSLdfESIE51anYNqt8pY/kmg0jAB0b8ebGm/OqBhC9jqL7FiOLWQKpVH+lalVa3EkpHdBeX24+edechgs22lXQ8wvskase2HcrVCGUfi4H94jWUelO6XifbRlolUwpHIn0xx/lkno4gHCMMV0KtQFdczmoJSKErLXmNoPGY87TqX1/8eei2ciPcb5JHJBEeUTn/LsOQCs1cw9Ewg6oGkUfSAUqGDRy6e8Mjw09l0R3D5KxOSLIG3OedZxh9iVKQnMhu9bmkEqLyf9j054m+eY7Z4Kpfyc96qWhl8muYycOc7ZheRYwLQbLz9arZnWh2zq9FefIRwgZMjgyppuOXG+6lfAvnsVLWtMKkFjzyJJ4bcrC2VZef/3VZuCnMDrXzgIr+Z+vA3esUsRcFSJiwPJANbPP4u1+oO26SOybC1lQQNZDD1PyFlJS/MGsg/ta88WdM1qsBPBnQHeOzQai2rEC//ciPiHC5ykRSk/oH3khYsWFacLiHt8mghIoO0ni4toh9xiNsfCLrjk1rqzXWKajPaEellXMOo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4491.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199015)(4744005)(2906002)(83380400001)(36756003)(33656002)(6486002)(478600001)(3480700007)(71200400001)(6512007)(6506007)(2616005)(186003)(91956017)(8676002)(66556008)(66446008)(76116006)(66476007)(66946007)(64756008)(38070700005)(8936002)(4326008)(86362001)(5660300002)(41300700001)(122000001)(110136005)(316002)(38100700002)(82960400001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WFdFNm0zMExwWE1PMVJ3eGR0ZTVHU2V5TXl5cGF6dDV0RFRidm9nTitTOEJj?=
 =?utf-8?B?QnhjS1dyR2UyQktaL21rYWtmcDZubUtkUWdMV01YZ1RBZFNhOC9McUdPdE9P?=
 =?utf-8?B?N1VSNlY5VVByMW5LaVJhOCtOUkE3b1ltb29ncHZZTXhUcmxJdlp6dVZZK1Yw?=
 =?utf-8?B?RUI5MUcvc0M5anBCdVhVbVlHckVWU0JyUStITEN0TC9BVUpsU1ZwN2dtdHps?=
 =?utf-8?B?b3d1Wm1BR09SSElOb0ptMEpPNkd6N3dVMElaR2c5RVZldUJ6S2RsNDloN0ZS?=
 =?utf-8?B?ZmZ2RVF6M1ZOVHdPc2FwODVMS3BNRnNodElGTldrK3JlVEVlNm1NQzJzM0hz?=
 =?utf-8?B?by8zcU9CMmo4VDh0dE1POURPTkRoUTV2NVllbHAzTEZ1WFZYbFFYdERidHBO?=
 =?utf-8?B?MUpMWVZSRkdITG12MUVkb1pzb1NNalY0ZzZMdE81YTNSMlVrcERiMnNBd2tt?=
 =?utf-8?B?TGlHd1FWeEQrM1RUUjNvclpoZEw4SnJqOE9NeVoya1N6M1pyeHRMb0lubUs2?=
 =?utf-8?B?dnlyWWFnVzg0eGZJbXZoOTEzZk10RjJBS3hXRENzcGxnWFdWeHQzTU1ZSER1?=
 =?utf-8?B?WWNGbUxFZk83alhtMGpIM3dGRE44YU1KemZ0LytMTTZTQzBwSWQrMXFKdkxK?=
 =?utf-8?B?RVg0SFZkK3dvZUdRL1Q3RGMxN1pCOE16VGZnOUhpVTZRc2Y4RktFZlVOVGsx?=
 =?utf-8?B?ZHhpNzhTRW5HcDQvU05DSWVKbHgyMXdscmZYMFo5ZG94UFZwbWtFMHIvVElr?=
 =?utf-8?B?dnlNQkRJaGRrMThBMldJK25Pd3BMbVlwMkl6V1ZiRXEyL3NZdm94RmpZRWRK?=
 =?utf-8?B?bUFwRjVaVXd4TjVNWDR1SkpXUzB3WGFUVkU1TUZYV3RwczBtWVZSclk4Nm02?=
 =?utf-8?B?dm5aWHhlSzFNRlAzQzdWWTEvSEQvaVYxQWxJN0ttZDQ3NWRncC9wWDBmOUdH?=
 =?utf-8?B?N05HSzd1OFh0ZW92RHdRVTBYTWxUVDZFRWtYbVpQUDNZamo1bHJmcVpWUHBw?=
 =?utf-8?B?N3FKTlFCSHJHTjJiaXZScFkvNjYyMktZVmsxNHU1R3VReUNnMTZ2TXdYajlX?=
 =?utf-8?B?dUtCTUkzdTdnd05lMlliMkxJdGEza1RQUDNrN0RpeURkL084R3pkTS9FNkpx?=
 =?utf-8?B?OE54a0t5WWJsazJxRG5PWFBzb2Q3WnhCRFNWQkNhRjBobVoxSUJtWWQrVmxr?=
 =?utf-8?B?KzlMcWo3NnFqeHRQelBnMTdDMHQzZjk4RmVjRytkWFZUNG4wdzVHQnIyejlC?=
 =?utf-8?B?T3VZNll1SkNyOGRRdURKMkQxL1pWMmhEanU4WjhzL0FvRkpuM1lWUFg0RjEv?=
 =?utf-8?B?S1d4K3JOcFdjZEl0clVhUXNYZG1aaEJZRlE1eWFpd2cvRGN1WUpEU0NpTDY5?=
 =?utf-8?B?MzRTSHZGKzYyUk92YXp1bXI4R1gvWTRyNWVsZnpRaXNuRCtwNndOYm4xNW85?=
 =?utf-8?B?eVFlK2lvUVdxS2xGQkROeTZGTWNMOGx0UWRTZ2YycnFXK29CbEsydit4TmR2?=
 =?utf-8?B?Um9TYzFmdDVsY0hIRFcrL25LbVl5S0dpWDdtR3M0dW05bXpJNE5yS05mM2xn?=
 =?utf-8?B?M1dSdFZ2OTdkYng3Wm82YStaR0xwdkQ3Umo2MVVNK0dvVDloSjEwWXpycFdJ?=
 =?utf-8?B?WlhYNFVjUEFmUjdYOGZnMGJoZG9jdmxpb2N4bnlwRDEwNXlrYUlndk9FcWEy?=
 =?utf-8?B?eVp2S1dYc0JVYkRIT3Z3T21JVStGdnVIK3NyTCtDRUVKN3l0ZzlvK1B3YVJl?=
 =?utf-8?B?eHZjbkZWV2RrZkg1RGkxSys5TWRBb2ZCSjdib3E2ZXcyc0k2RzhWa25pU3Jy?=
 =?utf-8?B?U0tTZExacWhBd2VDVkpLd2UvM1V5UFJTa3loZmN6Q2hEbXdNSUdsaEYvQXJZ?=
 =?utf-8?B?SXdyVEFwWDJwVExoWG1CUVUrbzBlN2VaTWxCTExic1A3OXFWR3VwbTNhSGp1?=
 =?utf-8?B?amRHSUFmY0NBSlNGZFZVWlJ3UFdBdjR1WUQ1TXJ2L1lwTno1UDFmRXo1RTBT?=
 =?utf-8?B?Y1Q2U0xpaDdEd1dIMG1JbXNFZllHZUJRTjZHNlphZVh0aXVGc2wrSm5aQ0E4?=
 =?utf-8?B?TTE2aUM2ZHhmcEFnZnhIcW5LU2RPeFljSjJJMlk4NFg0b2x0cWg2UStWMnFx?=
 =?utf-8?B?MWY2bWZFekZsU0tVeUNIMVNXSXJQRFp3RXg0VnEzR0dReVNEajJtZTVnaUZW?=
 =?utf-8?Q?s+ErrdwFy6s0vuBop5mwq31MNJThZIzAoaIzErsOlgG5?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E8C3EDB03557B04B94320B0B7E5296A5@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 9TYAfT0xGFaL8R8ELqSvdfmHvAf3dvm3eKbIMzHyIgIiyRt12TpGA11SmMhjHOMHSFRLoNCqJiKL61Duoz/c9qRzgwW1rfDB3ab89StaraShMQyrD7zboKdeyL3qRyQK90fEQgBaktJKN6GvRcZGEnXdJRYQ0ObgydPdBb8C8SI/E+Sq6QZxib6oRlFRYyPaeE7DA0bu3TTj/qZMtHdU8wi1E0CTqqZlJ4cIhqac5f7pZRgBALj4ynuC+cZASTM0Fj/pXrmaDMinzh10GS6Oa0+aDSYXdZNspFp4e5OeecdizKYrtRvL2fAx/QmamouNcNNjIM7BXNYekkPm9ECdSYWdddN1Id6H5JFkpEqkZUk0hpxjro1HTdHx+P2tO17A+IZFvtq0KMADUPLVPfLZwYmRH0TaFrPJDNXEmaBIt2zesB9kEtj9k225Nw8eryY2aM74cDdkaJwB9EfN6PeKHhZgrolka8+FAqoXPAPfjvm3ZsIqUHOF6wSIWdau+nLDNQoBLEvx2pqZh6WCXCPWjWFnlzBnzmfclU7SgtMwpJBZnVwVkTTjXLgCrUPNXHNAXsGJQV7M+Yln5avrmRFvAsYziZnLzE5bcaf21+wigakvDQ/NUCiw9ff3fGLB0ECHdXy4jXW84PBapbai060ZGSJh9tJl9EEHqckWAOCesfi+HbZ+yuf/zq/9PmB85Sgef1DkMRlrIZU8x9ML/rZR17v23tvB1PEiu1Ur78EXSmhHLyFk8jUj67NkGK3LvvbZmnzP107fN2lZqHV/5t3iUhAmGOxZEUpBoYRtQOWMpBwSKSSP3B8iAby+xVxC9cqVMnLJm/GVIww7gsiYBiQVBg==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4491.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86c1cacc-2374-48ba-2469-08dafafe98a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2023 15:54:21.5736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pfVvNoocPKSn49CIF9JSPaJ0mpG9uHaud0ytKtv4TMmUqGupztr1zPeF5hgFGE4H/GzpSaO9+Mq65yTWlsWkoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR04MB1263
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

KyBmaW8NCg0KDQpUaGFua3MgDQpCb29wYWxhbiBNIA0KDQoNCg0KDQrvu79PbiAyMC8wMS8yMywg
OToxNiBQTSwgIkplbnMgQXhib2UiIDxheGJvZUBrZXJuZWwuZGsgPG1haWx0bzpheGJvZUBrZXJu
ZWwuZGs+PiB3cm90ZToNCg0KDQpDQVVUSU9OOiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBv
dXRzaWRlIG9mIFdlc3Rlcm4gRGlnaXRhbC4gRG8gbm90IGNsaWNrIG9uIGxpbmtzIG9yIG9wZW4g
YXR0YWNobWVudHMgdW5sZXNzIHlvdSByZWNvZ25pemUgdGhlIHNlbmRlciBhbmQga25vdyB0aGF0
IHRoZSBjb250ZW50IGlzIHNhZmUuDQoNCg0KDQoNCk9uIDEvMjAvMjMgNjoyOD9BTSwgQm9vcGFs
YW4gTSB3cm90ZToNCj4gSGkgSmVucywgVmluY2VudDoNCj4NCj4NCj4NCj4gSSBoYXZlIHNlZW4g
eW91ciB3b3JrIG9uIEZJTyBJTyB0b29sIGFuZCB3YW50ZWQgdG8gcnVuIGRhdGEgdmFsaWRhdGlv
bg0KPiBwcm9maWxlIGZvciBvdXIgbnZtZSBTU0QuIENvdWxkIHlvdSBwbGVhc2Ugc2hhcmUgc29t
ZSBpbnNpZ2h0cyBhbmQNCj4gZXhhbXBsZSBmb3IgZGF0YSB2YWxpZGF0aW9uIHByb2ZpbGUuIFdl
IG5lZWQgdG8gaWRlbnRpZnkgdGhlIGRhdGENCj4gaW50ZWdyaXR5IGlzc3VlIGJlZm9yZSBnbyB0
byBjdXN0b21lciBwbGFjZS4NCj4NCj4NCj4NCj4gQW5kIGFsc28sIEl0IHdvdWxkIGJlIHZlcnkg
dXNlZnVsIGlmIHlvdSBzaGFyZSBwcm9maWxlIGZvciBtZXRhLWRhdGENCj4gcHJvZmlsZSBhcyB3
ZWxsLiBUaGFua3MgaW4gYWR2YW5jZS4NCg0KDQpQbGVhc2Ugc2VuZCBpbnF1aXJpZXMgYW5kIHJl
cXVlc3RzIGZvciBoZWxwIHRvIHRoZSBmaW8gbWFpbGluZyBsaXN0Lg0KDQoNCi0tDQpKZW5zIEF4
Ym9lDQoNCg0KDQoNCg0K
