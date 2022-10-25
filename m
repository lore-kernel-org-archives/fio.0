Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3235ECDFA1
	for <fio@archiver.kernel.org>; Tue, 25 Oct 2022 23:53:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbiJYXxa (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 25 Oct 2022 19:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbiJYXxY (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 25 Oct 2022 19:53:24 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA52C4C20
        for <fio@vger.kernel.org>; Tue, 25 Oct 2022 16:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666742003; x=1698278003;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xGJUDhLwIfIaHqmyFtcNLwDtxhlcYGlWUZadTHSDrPw=;
  b=c4ib9wKG5/ZL4RvENQOKTz/QVeW2T+GFlcnlTMd4lY7rHwO4ubl6OgIq
   6urQ9AaT9e6jr6ROQpqtNnq64q+P5BE0/3NZdwIWeQ8bLtglr2DDx040P
   kQkzs0fUPcEwu9Ro6uIuMf86n9uc4V1AAYHajon38R6R/Inmj+75PH1/P
   3vjfzvPL5t16WuUFZUXoMTWJu8ij3Cq6iBEGI5yjUByXpNyDC18NI55nS
   /RinvTQ0v9w3awtN1fRCCqeh8oXs59/+Ek9rqxIqTbcIX1XxYKa79Jy81
   xRerY2zS6i/VBsWv239f7FT0NMbZKPBouoOqVNebHaF/buGBhMP/T7Dt0
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,213,1661788800"; 
   d="scan'208";a="214730429"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
  by ob1.hgst.iphmx.com with ESMTP; 26 Oct 2022 07:53:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QuhwUlZMl/zrAQdgH72Ee0didDqrF5xnpggiNhZLJKUCBf2ofV2hL8ekXXd2aFBUuwRYMtRtbKIf/Y3xCRhi+WxObGrwEudlB4cBudMFTg2Dsx28kww/7/5S+jExZRJRQ0rKK2lT+wdNUVCv1HVdM++NjeoFBAjRNp9BOc8TDVqFKMYdGs5mt/4KsaFMd4dORW6gCQoCMgPLux1GuwJaVcHCfmz0uGR/Owa/FzEc6X/8Xf2FRalyOOd00biLmT/BmYCo3gbCKWqFUIiuueE7r/NcHlcxX8l0XHYvNNf+5G4x/D27QHIeJiv21u3TAxWsNchyvR2845mgXB7wH3NAMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xGJUDhLwIfIaHqmyFtcNLwDtxhlcYGlWUZadTHSDrPw=;
 b=WydwNS+YG/iIQXsKdo/qvjGxdk3+MaN65DVTYyKrvy2Y+cXfDnMLBoQCuPSjBOPtjWpjwHiX6CPm6A/7dT7EBc5f0/HtPeafYuOZb90tSnghAoEzbAiTGEMp/UjkGrYhCPDZRyU8rCPf8EAyDULjXUoNniiHugusY9bO0iTwn1xu1icnuSfSeYNqPno6E2/IZvbRwCvUb+AkBlkOavcWidvi8oNM1m+O5twyLEhveBBlhrdPiZBHIA08hQE4cw86yxFiWDLJVOlbmb5O9Pr2XGvuR2nKf0Anf7PlW5p+ntozt9A7BZP+UcnB2jaPyag+c708BlBz8V6FkSllQU4K/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xGJUDhLwIfIaHqmyFtcNLwDtxhlcYGlWUZadTHSDrPw=;
 b=Z6XDde4IeN1INGm4spDJTPYwl24B3UO1losYi1cCMrxJBB6NFaEJSeWO9NUhVGgEfHPcL1MG8a/ijFuiWebpfYuDOK0ORRv8jlZdkJZE5MguChlpxqyp4Dem2UdS2JztAf4YzyuNceqAuopMLzF/zKgaZgCmMEP4NMs2HbqiO7c=
Received: from MN2PR04MB5951.namprd04.prod.outlook.com (2603:10b6:208:3f::13)
 by SA0PR04MB7244.namprd04.prod.outlook.com (2603:10b6:806:e4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Tue, 25 Oct
 2022 23:53:21 +0000
Received: from MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::51df:fdd7:7c49:12ee]) by MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::51df:fdd7:7c49:12ee%5]) with mapi id 15.20.5723.032; Tue, 25 Oct 2022
 23:53:21 +0000
From:   Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "vincentfu@gmail.com" <vincentfu@gmail.com>
CC:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH 05/11] zbd: verify before zone reset for
 zone_reset_threshold option
Thread-Topic: [PATCH 05/11] zbd: verify before zone reset for
 zone_reset_threshold option
Thread-Index: AQHY5RcrTLj8Y/XpAEu/DGYVLCEZTq4fz7wA
Date:   Tue, 25 Oct 2022 23:53:21 +0000
Message-ID: <fd5434e080e33675f2c80dae0a6bc1632380a830.camel@wdc.com>
References: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
         <20221021063416.860438-6-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20221021063416.860438-6-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB5951:EE_|SA0PR04MB7244:EE_
x-ms-office365-filtering-correlation-id: 5fed2b97-90d1-4a4a-62db-08dab6e41905
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: en0WiigLcVxLmnzGBfoh6XK8p60U3XRkJ97iGDAaZ14u9isMpOA40TBvXJXNLWP0PNI94NNNBiCGZjDkE8TwocO2wboASqgO/OfmsHiqgrmI/CaZhNuGC0Z87TRT95EFGyPMjCU/MgBlvO5nalvSljuq3Ykrl22cmJeSSBbCL7PhZpFrYFm0yBZegJKJwWaXW9cM6cR6N1SLsk80oEL39dQmo9OlZvSUpmOXncVTEZCxwAxSvX1Zf84TXNjELvLgU74HJfo+SwL26ykiYhMMoC3chbdQNIMqVXcRlVQQUFJozGADbBgd2ZL1Ww6PRcn9bSZluUqpGJ+4+ZfsiRXJkeIlQbxXwxqKKuzh0Xeve12u5LU9tSPA/cAEwuq37Hcf7qkSyFooN7N3x8U7cRk3SCbs+t7LujCLJVQMXo5nG5xO6c3seWGy2Oq8AgX5MmuWje6TsNPadCUX3pA9YFYgW1WpoLneIWixHA8V1tO3/8GkUG5WhuT/Pv23boayHBwECLSgyo02DhjBoUmY5V1VDlIMimGJmQZYIcCYtgD0epwWLKuCPN1sPg0owGjB5dxkvKSR7332r8AuMhMefbxgAld6Q2gvQ9/5uy+AmdULEKBe88z86Faa3WLMSrSuqckxwb/PBoP3nlAlqxxfuFvQhYtMM73FqK9lKaToxdMTfwZ2sCZwW8WlzuyM2Bx/v+DaTs9B8If5nKnLWlV2/NgaXbAHOSLIOvQLC9aIrt/OUME6O9pm6ThvUHIbRa/eIha1MRLD5pLLARg5PeH2h4HL7g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB5951.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(451199015)(6512007)(41300700001)(36756003)(8936002)(38070700005)(54906003)(4001150100001)(26005)(110136005)(86362001)(122000001)(316002)(6486002)(82960400001)(83380400001)(38100700002)(186003)(15650500001)(2906002)(91956017)(76116006)(66946007)(6506007)(66556008)(8676002)(4326008)(66446008)(66476007)(64756008)(478600001)(5660300002)(71200400001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RCtoSWdxbStLYW1MdUU4dDA1dGRtbXB1UjYvYzVwNVM3THVHN2tNT2IrbUdw?=
 =?utf-8?B?RkFtdFAvS3UwT1NBTmhsZ2JuMUUvRWVwVEt3SkJQZ3RMZ1RRaDQ3TzhlRTN5?=
 =?utf-8?B?MW85OGI5a2Y2VEQ3MVVZQUkxOVFyRkpSTW1sdDhZMENFQWlnSU5kTExzUDVs?=
 =?utf-8?B?M0tWZTJMZE5wTjBEUzZmOEhXWERJVGdObDlZTTk3WXlTUGUvOTAyV3dHVk5w?=
 =?utf-8?B?SXMvWm0zcGVQN1NGSS9XUE53OTNubVdLZnV6VkFmdEp5YzI4Z0Q2TFFWcEdO?=
 =?utf-8?B?ZUJLc2JRQUJaeWsycWU3b092a3NxVENzaU1aZGZ4Y0lvSXhGUXJpcXlJeEFQ?=
 =?utf-8?B?QUlFQkVJSmMyY29sc1lldzdBQ1dMRHEzVCtUdTVwU2hUd3ZPRElQeGRtaElH?=
 =?utf-8?B?YUZqM21GUk90SUxrb1Mwak4vVEpXcy9jTDZVblhybk1Melc5TVRJcUtSUEt0?=
 =?utf-8?B?ZmY2ZE1pSkEvT0JuOEx2blFyajVYOUpRZGc0WTlUMEpKM0NLODl2R3Z0ekVp?=
 =?utf-8?B?Y21OM05UN3lGemdTZDFVcDA5OG1FbE5maDNQK29Va3F6bUdCYzd1c2V0czhz?=
 =?utf-8?B?SkxZdG9wTmxVczBrTzdpUGd0U2VxUlJIanZDR3hjdklrVEF2aVZUUnhhZkUv?=
 =?utf-8?B?TGRoRExLZnpSenpkOGRONm5EUnhaTkVDYjJHd1lSQUIzMTh3ODk5ZVI1Y1JQ?=
 =?utf-8?B?MVdseE95Ujd3UDRHUElEenI1NUR5Z0dOTGVDbC9FTy9FNFNGOXlxZEpTeWxC?=
 =?utf-8?B?emM1Rm9ZcmVUMlVLMXJvTkV1cEpJcUlMYkRPTTNxMHdKVldNa0pWUUZtajVX?=
 =?utf-8?B?Ny9HMVNTNmgvYXNabG5LajF1Q3lkNTlXeE0wbUQ2d3ZRUm1nK2dvdlUzMElr?=
 =?utf-8?B?QndwaGp6UUtQcXVOc1BjdVQ4NEVaSVVoRmkzUm01UW1KU2Z3MkZWcVpVMFdB?=
 =?utf-8?B?S3V3VFFhT3l2ZEdyVFNPYTkvaWNZZU5rbWlaQWZQVmRoV1hkVE5peUxSM0hI?=
 =?utf-8?B?WEJNYVp0MXJycTZJdmd1bWdpNGtmR1FBNVVtTW13bkVWS2ZpSHE1c3EwK2pm?=
 =?utf-8?B?cWh6bWE5bno5R2ZoYnArbm5wWHJzeGZJTG1ibTNNckkwYWpCZ3JoRTBJMXd6?=
 =?utf-8?B?VWlFc0J3Slp2M3FSSC8zMkR4dnVESHZhZE01TjFrZk9tUnBkQnZZa2VscHdq?=
 =?utf-8?B?ZWRNQndQeExSYzRKajVFU0UvamVZU3dOVHBqdS9DUVcwdzlhWjUwKzVTRHZ1?=
 =?utf-8?B?blVzUWJJTVFVV2lENm11MURnNy9HbHBMbW5Xd3NIUmNzcjJvbUdBY1RXSUtH?=
 =?utf-8?B?cFVFcE5NUGdQQ2pGVXp1VFJDQzVZNGNONkJuWlNVeERXalVIMjBaNTFwTlJM?=
 =?utf-8?B?OFVMdVJpdHhPa2ZmV0ZyZ3R5eUpmNElncmVkNkNOdmdoUzZqZTl2ZDVhc0tR?=
 =?utf-8?B?Sm9wa0tJcHRZT3dlak5neS9GUHZKYnl3RDhwVWYzVTVXYytrc001dStIRklQ?=
 =?utf-8?B?RHlZK3dUNFRrREtzUTRSbk00MGlMS015MG9GMDRBdWwzUFZEazZIYjBqdHFV?=
 =?utf-8?B?ek5SQVFTRTJhN0tDZE81alB0UnBqQ3A4eVh3cGVzb2xnV3FmNTNqQ1NwdDhT?=
 =?utf-8?B?NVp3UkMycCtteFFWNTJrVjh3a1g2ekVKYmY4Q0xqTWR4ckpNdUc5NWFQT213?=
 =?utf-8?B?NmJ1ZmJMWm9hZnlwQk4vK0dqZ3J3U1N2SVo4dWYycVRqV0ZacnRZeTM2eTdN?=
 =?utf-8?B?RmVjd242Q0J4bGlhd3F3Q0ZueEd1Rmw3RVBBTlFpNU9ZeVI2eU5MR25qMDBr?=
 =?utf-8?B?WnlFaWdueHIzUzBCZTBteVYrWUpmTEcvMitjV08yaThRRjF5RkJZQ29DRkYx?=
 =?utf-8?B?Z2g1T2pvYXo3S3l6QWlRWkFZL1NQV2ZDZGZ0Y3hVWWtjajdjcjNWcFJRRzMr?=
 =?utf-8?B?TWswMXhQVDJXY0ZPeGZqQlg2OUh0cW91SzlybDUwWEVodzJubG1yaGwyaUhT?=
 =?utf-8?B?S3V6cGFXN1NxbTgzbkhYbmlwazJzekN5S2JnKzQ5cXUrQzV2cWZRcFhwSFFW?=
 =?utf-8?B?MWJDUkFGNXdPNzREcTZHdHk2VklzNmFRZU1sNm0xdndFTjZlUTBnWDZJd1FC?=
 =?utf-8?B?REJEUmErVFplQXZKU0dvdWIwMHFRWldJaHBTN3RCN2FOR2hVanNYU1EvbVpG?=
 =?utf-8?B?ZkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <68C50FBAFF2E2548A0B4CB49C7A3B6DF@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB5951.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fed2b97-90d1-4a4a-62db-08dab6e41905
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 23:53:21.4303
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pN6nQe9SYwTtAHU2zrAiVLYkIlDmDKQ10i4xjWuLhPYt72s3kR7WqdtDTUvcD9b/jatr2nMzwHnIJTiQaXd/AQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7244
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

T24gRnJpLCAyMDIyLTEwLTIxIGF0IDE1OjM0ICswOTAwLCBTaGluJ2ljaGlybyBLYXdhc2FraSB3
cm90ZToKPiBXaGVuIHZlcmlmeSBvcHRpb24gaXMgc3BlY2lmaWVkIHRvZ2V0aGVyIHdpdGggem9u
ZW1vZGU9emJkIGFuZAo+IHpvbmVfcmVzZXRfdGhyZXNob2xkIG9wdGlvbiwgem9uZSByZXNldCBo
YXBwZW5zIHRvIHpvbmVzIG5vdCBmdWxsLiBUaGlzCj4gZXJhc2VzIGRhdGEgZm9yIHZlcmlmeSBh
bmQgY2F1c2VzIHZlcmlmeSBmYWlsdXJlLiBDdXJyZW50IGltcGxlbWVudGF0aW9uCj4gYXZvaWRz
IHRoaXMgc2NlbmFyaW8gYnkgYXNzZXJ0Lgo+IAo+IFRvIGFsbG93IHpvbmVfcmVzZXRfdGhyZXNo
b2xkIG9wdGlvbiB0b2dldGhlciB3aXRoIHpvbmVtb2RlPXpiZCBhbmQKPiB2ZXJpZnkgb3B0aW9u
LCBkbyB2ZXJpZnkgYmVmb3JlIHRoZSB6b25lIHJlc2V0LiBXaGVuIHpvbmUgcmVzZXQgaXMKPiBy
ZXF1aXJlZCB0byBhbiBvcGVuIHpvbmUgd2l0aCB2ZXJpZnkgZGF0YSwgY2FsbCBnZXRfbmV4dF92
ZXJpZnkoKSB0bwo+IGdldCB2ZXJpZnkgcmVhZCB1bml0IGFuZCByZXR1cm4gaXQgZnJvbSB6YmRf
YWRqdXN0X2Jsb2NrKCkuCj4gCj4gU2lnbmVkLW9mZi1ieTogU2hpbidpY2hpcm8gS2F3YXNha2kg
PHNoaW5pY2hpcm8ua2F3YXNha2lAd2RjLmNvbT4KCkxvb2tzIGdvb2QuCgpUZXN0ZWQtYnk6IERt
aXRyeSBGb21pY2hldiA8ZG1pdHJ5LmZvbWljaGV2QHdkYy5jb20+ClJldmlld2VkLWJ5OiBEbWl0
cnkgRm9taWNoZXYgPGRtaXRyeS5mb21pY2hldkB3ZGMuY29tPgoKPiAtLS0KPiDCoHpiZC5jIHwg
NSArKysrLQo+IMKgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigt
KQo+IAo+IGRpZmYgLS1naXQgYS96YmQuYyBiL3piZC5jCj4gaW5kZXggNjE4NTZhZDEuLjM4NTVh
YjBlIDEwMDY0NAo+IC0tLSBhL3piZC5jCj4gKysrIGIvemJkLmMKPiBAQCAtMjAyOSw3ICsyMDI5
LDEwIEBAIHJldHJ5Ogo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAvKiBS
ZXNldCB0aGUgem9uZSBwb2ludGVyIGlmIG5lY2Vzc2FyeSAqLwo+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgaWYgKHpiLT5yZXNldF96b25lIHx8IHpiZF96b25lX2Z1bGwoZiwgemIs
IG1pbl9icykpIHsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoGFzc2VydCh0ZC0+by52ZXJpZnkgPT0gVkVSSUZZX05PTkUpOwo+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKHRkLT5vLnZlcmlmeSAhPSBWRVJJ
RllfTk9ORSAmJgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgICFnZXRfbmV4dF92ZXJpZnkodGQsIGlvX3UpKQo+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gYWNjZXB0
Owo+ICsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAv
Kgo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIFNp
bmNlIHByZXZpb3VzIHdyaXRlIHJlcXVlc3RzIG1heSBoYXZlIGJlZW4KPiBzdWJtaXR0ZWQKPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBhc3luY2hy
b25vdXNseSBhbmQgc2luY2Ugd2Ugd2lsbCBzdWJtaXQgdGhlIHpvbmUKCg==
