Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B032FA3740
	for <fio@archiver.kernel.org>; Tue, 25 Oct 2022 23:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbiJYXzD (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 25 Oct 2022 19:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbiJYXzB (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 25 Oct 2022 19:55:01 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38F43387E
        for <fio@vger.kernel.org>; Tue, 25 Oct 2022 16:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666742100; x=1698278100;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7n2tYQdFYeVeuIDDt2zKDVexeY+hZRKIM2g2AY7VcMU=;
  b=UZ0sp7bIDuwZb3Uee0PYqBwmWoGKFR+skMtnhLyYlDFx3mZF2rCO1nnH
   FExU5gFGtt4Za+CSyh8+AH64ulZyyLnRf2XPf+/PbRrZo7MxK1mAr9mLs
   VbForcz2MPQD4/J9HNASDT7/Kd1ULyzWgaH7PwvcMIV6SEzWH8QYS12YS
   nAaNLizIVmxTjJgPetK5N9LEb3QkSYKnD6uMTi7TaWOjQ8iXDXkzZ/ix7
   UE3dN6xpG1Bnm/ExaE+hpOJz6cT8B8PqLWqB0XGsUEp6yhtsu9Mt5s77d
   TCRtYsY/t0EH9c5sFvD2vEJGI9Mg2/hlVGz4JCdVcT9Z+oXgaRiVYcFdc
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,213,1661788800"; 
   d="scan'208";a="326842715"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 26 Oct 2022 07:55:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JyWDUygjgcg8Vga0haIxjhWd4Jo5UDMmCHX77Yjs/t1Tnp07sdytGQJHV0PfTeEy18DM8jMpjIO6lhqQkaRP87inA2rS1MiQSn/IKGCpajFx+ybra5tnB14PXkPq1TowqqLt9aXPIugcY+rNgP5KO3AcR9227q82kvl5tJOhrg41mmqb7ER6+hm4X9y+xprHh0SIHEgNpfo34UtQeUr+8BR01b4xsPMFbIYzqwxF2evUPuRwoYXX2EUkTDSmVZVi9B9SCp8Lvfu07MsBqzH4E6F8XB2pQepkBCnlE4EWC74wVtsbek0h10n1cLQ72QcFb8c0W/3Wf3hIAP/BtRqiHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7n2tYQdFYeVeuIDDt2zKDVexeY+hZRKIM2g2AY7VcMU=;
 b=maX0upmc8q08O9HUgA7DuYGL4XIa4wPgTn6F0rRSxLy5P9K+LoObgSjx09VYv7qcPokQLGc3GjLdruG/SxV1nlrxifC9KsbepuLyHcOtHE1jiEtic5M3+zRY7chBW4RuRRQUZmKIAlDuzart/+q2kYGMyHtM+NmvZrZwPIqOwVQnTblvBefrEo6xNhl7G7jzveJAbOUnrIZyow3r4pkpmzBx+sxyJl8YaYUHYUxSTQS12GZ7xudHpQExpfHiRnmEzuCCa8syxKLO8BjaaKjRMOat7qD4P1XCL+8W/E73ynr0IvpxTLXnZHfJo53IloIYUda7fV2MouRIHiSxdEfFLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7n2tYQdFYeVeuIDDt2zKDVexeY+hZRKIM2g2AY7VcMU=;
 b=zRdzMha1JuVV2onCtgIty6soZy/idLh+vaFigDsO4SY7jvwZUE4rQne8/s30i2AOv3XoRGIEFX9rEj39KF+75l4ynmYbQBQomu2MJhl7kKyVmiGfq/VCYdkw3oLr5/RmJwbh4anB6z17r/fdxVDR6/6G5TtnF8fikfbCo384R+g=
Received: from MN2PR04MB5951.namprd04.prod.outlook.com (2603:10b6:208:3f::13)
 by SA0PR04MB7244.namprd04.prod.outlook.com (2603:10b6:806:e4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Tue, 25 Oct
 2022 23:54:58 +0000
Received: from MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::51df:fdd7:7c49:12ee]) by MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::51df:fdd7:7c49:12ee%5]) with mapi id 15.20.5723.032; Tue, 25 Oct 2022
 23:54:58 +0000
From:   Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "vincentfu@gmail.com" <vincentfu@gmail.com>
CC:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH 08/11] t/zbd: fix test case #33 for block size unaligned
 to zone size
Thread-Topic: [PATCH 08/11] t/zbd: fix test case #33 for block size unaligned
 to zone size
Thread-Index: AQHY5RcuPIvmQPUccUSlC4H1+tAMpq4f0DCA
Date:   Tue, 25 Oct 2022 23:54:58 +0000
Message-ID: <fea088e8ffb555bcc6f3058bfcd76eb97b8e84f3.camel@wdc.com>
References: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
         <20221021063416.860438-9-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20221021063416.860438-9-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB5951:EE_|SA0PR04MB7244:EE_
x-ms-office365-filtering-correlation-id: 4700fcf5-6870-4b07-8f1e-08dab6e452d0
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1rCs9nh0yuDmbeNKgUkpEwRBUWgZImoIREc/CF/F2DtuTnNBva5PsMJ8wZiQ4/Vdxhjmn7LwwOcWgVTGReVpwmfqBLWIPua9qX8aQm0S+rwZaY2HnQQ4OJeNvTaYUItz2Tgc14PPyGmoQaRsN4phrHBbrwaEzwintYdRwLShb6JokVh3K8MfkLdq3d6CRkPPdzFMHm8QATv6hCBRvl6wyU5aEjPyQYDeLV5+ZmUky8mXUsLxpods3J8+jw72zxkCsm7iOFe+cmvP5qAU/7jZlmdINYBwHE5nq0ePxug4YrOD5Fpy1WRn/zuM317DAMd8/S6tzJJpWLX6v+wZk8tGOlIKIkzu1hNrarGytwy2XUVwfb9WbjDPvN7mvEBw988kgaFYq2Pbw+m9r7YGe7PdiP70toHz/gBO8c4sCAYqv3qESfy6IK7YlTVxHb/sss7qG70IURJ4ZUj28FS/r65jFgUtkD1viGqPNAgJ9tgCXlPRPHN7URKqAB1puCmoMaWtYKsll57W4kWb1Bkssk/+yLVox2Px1+l8Wm6wHMx2OvFlpqmDakVKm3mlJj9nW+XcGM6ypd1SJOau6Kyrtx0eq7wKRzGzRJ4vxPWu/+kun8eF7DAA/lC/1aOeC84Ps5vG2gO//zWcXZL+reI8fqAMAlXPU+Dig6vJT+a2xAG/wSu6kXy/WOp4jpxLM7mFHGIfa76NmKFl5utAQyVjlg7XXYbjYpgXXlOE0aCeh3/pwYIYUYicfW/4Xp6Je89QS5YiKFiq1DRgunCcWY1w3yQdSQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB5951.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(451199015)(6512007)(41300700001)(36756003)(8936002)(38070700005)(54906003)(4001150100001)(26005)(110136005)(86362001)(122000001)(316002)(6486002)(82960400001)(83380400001)(38100700002)(186003)(2906002)(91956017)(76116006)(66946007)(6506007)(66556008)(8676002)(4326008)(66446008)(66476007)(64756008)(478600001)(5660300002)(71200400001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MGJFeXN5TUU0RmJoWTNxZVFjVVM4cUhSMmljb3hxUzZhdXNrZkRvMTJVSlUy?=
 =?utf-8?B?RldKQnZqcFI3QnViNjJhdlJVaGo3d2E0ZTZxQnpxMWtqNE16WmQvTEFLOWE1?=
 =?utf-8?B?RzN1UXVJZHd3eHMrdWVkcFI4SHAvMVV6ZHRqVUFWRFVESXpQQzN0Ti91UVRZ?=
 =?utf-8?B?UFA0aW9acVhJUHk5WjFlZFFzRncrT2pzUWI4SllYdWNwTmtNa0MzWnNMVHFU?=
 =?utf-8?B?NjdIZnpQdTI1NGpKTEFuVXZpbndjWGg4dGFMbVhVenFIN1pGY1Z3MmtRRnB3?=
 =?utf-8?B?RmgzaldmUjBLNllKcnBpakFicko0ZmxKSS9KS3JNQkFxZ2pKd0xDRWNJcE84?=
 =?utf-8?B?OGxobWlwV0hjaUhLUE1IL1I0T0FHMTdqbmViWHE5SFVsNHUrVi9nYS9ZbEd2?=
 =?utf-8?B?cldjeFpLcFU3OTJjd2hYRDcxRnBpUzJGblNUanl0WWorL2t5NENUREp4ckxi?=
 =?utf-8?B?YVh2YmVFL1RHR1pPbTBMc1pvYk9aTE9MYTYzbE9QQVNjOVRWb0J4cnZkbWVB?=
 =?utf-8?B?YnN3ZkJnRGRtKzBXb1EzKzZRcHR4c3R4UHBYbTN1UWZDamFmSENneTRRREpq?=
 =?utf-8?B?VUl2cG1WZlR3QjZUSG1MQzF6cWlleDZlTmVtT0dpeXhUUCtQd0NlNi9DNE4z?=
 =?utf-8?B?TFdEYUV2ajhHTjYzeG0raFM0Tk1qOGx5QVRJQithTTBNUm5pcUJZQTR3Qzcz?=
 =?utf-8?B?UXJLTGlZMXVhc0NzQitoQzl4dWNFLzAxVFdhMWorZUhiMVBjTWJ6S01ZL2NX?=
 =?utf-8?B?QnZxTDJpUkVodVgrYVZLWUVITzFpV0RDZ2VJQTgzMExjUWtIUEpWRmV3ZnVC?=
 =?utf-8?B?SUxXOFdIZXFSVzJxYUhrRm1hWjJKcGxLTkY3aDJBOG9GS1FoT2F4TW01RDc5?=
 =?utf-8?B?elVkVjArYnp3eTJWV2hDTVpNR2xNT1p6Z2dCajBqNWRveGlSNTdlUnRZc0Uv?=
 =?utf-8?B?YkRaK05zUlFUUGtUUjJza3ZGZlNyWGs3OXVaZXI1R2h2WVRlT0g3YitDVmhW?=
 =?utf-8?B?THBwUXZqQ3M2REdnTm5WMG50Mkt4SGxmMmVtaW1wY1Iwb2FyZGh4NUtrNmRz?=
 =?utf-8?B?aUphYzNyS29WTUcwNkxnaWVOdktOYTNGMUdRZ3k5eEZPM1pBdmdEYXdOWFVh?=
 =?utf-8?B?SzVtbm5IaEtqVzQvamRNaXRxbnNCblAvcDFucE9vbytqdTRLcEo4NDhndkJq?=
 =?utf-8?B?aUJFdThURlF1enBMQmxmY0l5Y2VLNE1aRnpLN29nK05iZ2JzWkFxZnRVL3Fz?=
 =?utf-8?B?Yi9qTjJzRnJmSVJDUmFYS0t2d3NobTVIQ0lGTVZ4a215ZTBNVHBaNkxiR09w?=
 =?utf-8?B?SGwzaTB0d2NiRjhIUVJEZ2MvQ0pVZmUrWWZjVW1vSVhLQUh5ZGM5Q1daME43?=
 =?utf-8?B?SjRaL29vZ1hPT2lOVlUveVRtRTlOWTZLV2FFNDlBNWFEMDRENjdkOXV3VFph?=
 =?utf-8?B?MDJ0dUNQcjY3alR5Z253OGFnNGUySVJCTzcwYUV6QlIyRlNTWjVIQzlVTERR?=
 =?utf-8?B?NzBvdHY1U1ZCbE1tVUMzMDYzT1FUZGlEV0pyRG9OR0NjcWU1ZzdvU3hhcGJn?=
 =?utf-8?B?aTZUU2pwRFhKL0c2QlB4am01V3V1OG5NSG9tajNWT3pkUVN6NktiUHFQRVRj?=
 =?utf-8?B?T0RHanJxQkllUVFKcUVqd3E1aWtXSkpESStrM0VMYjhLVnF5cFFwUEVLUUFn?=
 =?utf-8?B?bFBYb3pCWHVMQmRZTERvcXB6UXpzYkxMUkYvYnU0ZGdMVUlEWkVKdmJMSUsw?=
 =?utf-8?B?VU9MV3J6RzNqZDNwSlV4RFdJNWY1UmViUWtDalJVa2hpOXpSSjdCS2VXLzd5?=
 =?utf-8?B?OEpDRWV1TnJrOFJEbGQwTXA3clR5YVJWVXM4UU9OekdkTVdyS2Fjbk9BaDlN?=
 =?utf-8?B?Z0VkQy90eXYyd0publFlTWRwWUlsUU1vUHV1NUpVY2xrWFRMUkJ6akM4Smky?=
 =?utf-8?B?RTVUdG4vSUFEWk5zUTloWkFoRTFvZkF5bDAxdWxxM0FRbVAxa0FnY3dVK2Zl?=
 =?utf-8?B?THJlb016VjlBai9kWkNSRldIeVpoRzZ5RXkwRGN5SlI2K3lLdDB4cEorQ1NB?=
 =?utf-8?B?UmRmSmpUaHdERE0zNXJzOS9mQ2NxSDNWL1BlaFY4VnhIWjVzakhlazJDRkJl?=
 =?utf-8?B?TTNDcm53a3FBNnFvV3l2TndEMmtaaE52Zm1UUDF4VkJyM3Z3VE1nQndrazVU?=
 =?utf-8?B?RVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7086D6A6C12E624CB4B82BAF861FE0DC@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB5951.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4700fcf5-6870-4b07-8f1e-08dab6e452d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 23:54:58.4232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qs4NnvrOr9ivu7fVDzEsEgROMG8QmJxF8VywzPryOz8KvgNKgRSYB25uX8OI66lKWdyWNeSXHbNuhMqNxYfB3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7244
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

T24gRnJpLCAyMDIyLTEwLTIxIGF0IDE1OjM0ICswOTAwLCBTaGluJ2ljaGlybyBLYXdhc2FraSB3
cm90ZToNCj4gUmVjZW50IGZpeCBvZiB6b25lbW9kZT16YmQgc3VwcG9ydCBmb3IgYmxvY2sgc2l6
ZSB1bmFsaWduZWQgdG8gem9uZSBzaXplDQo+IHVudmVpbGVkIHRoYXQgdGhlIHRlc3QgY2FzZSAj
MzMgaGFzIHR3byBpc3N1ZXMuDQo+IA0KPiBGaXJzdCBpc3N1ZSBpcyB0ZXN0IHByZXBhcmF0aW9u
LiBCZWZvcmUgdGhlIGZpeCwgd3JpdGUgd2FzIGRvbmUgdG8gb25seQ0KPiB0byB0aGUgZmlyc3Qg
em9uZSBkdWUgdG8gYSBidWcgaW4gem9uZSBzZWxlY3Rpb24gd2hpY2ggaGFwcGVucyB3aGVuDQo+
IGJsb2NrIHNpemUgaXMgbm90IGEgZGl2aXNvciBvZiB6b25lIHNpemUuIFRoZW4sIHN0YXR1cyBv
ZiBzZWNvbmQgem9uZQ0KPiBkaWQgbm90IGFmZmVjdC4gQWZ0ZXIgdGhlIGZpeCwgd3JpdGUgY291
bnQgdG8gdGhlIHpvbmVzIG1heSB2YXJ5IGlmIHRoZQ0KPiBzZWNvbmQgem9uZSBoYXMgYWxtb3N0
IGZ1bGwgc3RhdHVzIHNpbmNlIHRoZSB6b25lIGlzIHNraXBwZWQgZnJvbSB3cml0ZQ0KPiB0YXJn
ZXQuIEZpeCB0aGlzIGJ5IHJlc2V0dGluZyB0aGUgd3JpdGUgdGFyZ2V0IHpvbmVzLg0KPiANCj4g
U2Vjb25kIGlzc3VlIGlzIGV4cGVjdGVkIHdyaXR0ZW4gZGF0YSBzaXplLiBUaGUgdGVzdCBjYXNl
IGNoZWNrcyB0aGF0DQo+IHRoZSB3cml0dGVuIGRhdGEgc2l6ZSBpcyBsYXJnZXIgdGhhbiB0aGUg
aW9fc2l6ZSBvcHRpb24gdmFsdWUuIFRoaXMNCj4gZXhwZWN0YXRpb24gd2FzIGZpbmUgYmVmb3Jl
IHRoZSBmaXggYmVjYXVzZSBkYXRhIHdyaXRlIHdhcyByZXBlYXRlZCBpbg0KPiBkb19pbygpIGFu
ZCB0aGUgbGltaXQgd2FzIGNoZWNrZWQgd2l0aCBpb19pc3N1ZV9ieXRlc19leGNlZWRlZCgpLA0K
PiB3aGljaCB0cmlnZ2VycyBsb29wIGJyZWFrIHdoZW4gd3JpdHRlbiBkYXRhIGlzIGxhcmdlciB0
aGFuIGlvX3NpemUuDQo+IEhvd2V2ZXIsIGFmdGVyIHRoZSBmaXgsIHRoZSBsaW1pdCBpcyBjaGVj
a2VkIHdpdGgga2VlcF9ydW5uaW5nKCkgaW4NCj4gdGhyZWFkX21haW4oKS4gQWNjb3JkaW5nIHRv
IGNvZGUgYW5kIGJsb2NrIGNvbW1lbnQgaW4ga2VlcF9ydW5uaW5nKCksDQo+IGZpbyBqb2IgdGVy
bWluYXRlcyBldmVuIHdoZW4gd3JpdHRlbiBkYXRhIHNpemUgaXMgc21hbGxlciB0aGFuIGlvX3Np
emUNCj4gaWYgdGhlIGdhcCBpcyBzbWFsbGVyIHRoYW4gbWF4aW11bSBJTyBzaXplLiBUaGVuIHRo
ZSBleHBlY3RlZCB3cml0dGVuDQo+IGRhdGEgc2l6ZSBpcyB0aGUgbGFyZ2VzdCBtdWx0aXBsZSBv
ZiBibG9jayBzaXplIHNtYWxsZXIgdGhhbiBvciBlcXVhbCB0bw0KPiB0aGUgaW9fc2l6ZS4gVGhp
cyBpb19zaXplIGNoZWNrIGNoYW5nZSByZXN1bHRlZCBpbiB0aGUgdGVzdCBjYXNlDQo+IGZhaWx1
cmUuIEF2b2lkIHRoZSBmYWlsdXJlIGJ5IGZpeGluZyB0aGUgZXhwZWN0ZWQgd3JpdHRlbiBkYXRh
IHNpemUNCj4gY2FsY3VsYXRpb24uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBTaGluJ2ljaGlybyBL
YXdhc2FraSA8c2hpbmljaGlyby5rYXdhc2FraUB3ZGMuY29tPg0KDQpMR1RNDQoNClRlc3RlZC1i
eTogRG1pdHJ5IEZvbWljaGV2IDxkbWl0cnkuZm9taWNoZXZAd2RjLmNvbT4NClJldmlld2VkLWJ5
OiBEbWl0cnkgRm9taWNoZXYgPGRtaXRyeS5mb21pY2hldkB3ZGMuY29tPg0KDQo+IC0tLQ0KPiDC
oHQvemJkL3Rlc3QtemJkLXN1cHBvcnQgfCA1ICsrKy0tDQo+IMKgMSBmaWxlIGNoYW5nZWQsIDMg
aW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS90L3piZC90
ZXN0LXpiZC1zdXBwb3J0IGIvdC96YmQvdGVzdC16YmQtc3VwcG9ydA0KPiBpbmRleCBjZGMwM2Yy
OC4uZGViZTM3NjMgMTAwNzU1DQo+IC0tLSBhL3QvemJkL3Rlc3QtemJkLXN1cHBvcnQNCj4gKysr
IGIvdC96YmQvdGVzdC16YmQtc3VwcG9ydA0KPiBAQCAtODEzLDcgKzgxMyw4IEBAIHRlc3QzMygp
IHsNCj4gwqDCoMKgwqAgbG9jYWwgYnMgaW9fc2l6ZSBzaXplDQo+IMKgwqDCoMKgIGxvY2FsIG9m
ZiBjYXBhY2l0eT0wOw0KPiDCoA0KPiAtwqDCoMKgIHByZXBfd3JpdGUNCj4gK8KgwqDCoCBbIC1u
ICIkaXNfemJkIiBdICYmIHJlc2V0X3pvbmUgIiRkZXYiIC0xDQo+ICsNCj4gwqDCoMKgwqAgb2Zm
PSQoKGZpcnN0X3NlcXVlbnRpYWxfem9uZV9zZWN0b3IgKiA1MTIpKQ0KPiDCoMKgwqDCoCBjYXBh
Y2l0eT0kKHRvdGFsX3pvbmVfY2FwYWNpdHkgMSAkb2ZmICRkZXYpDQo+IMKgwqDCoMKgIHNpemU9
JCgoMiAqIHpvbmVfc2l6ZSkpDQo+IEBAIC04MjIsNyArODIzLDcgQEAgdGVzdDMzKCkgew0KPiDC
oMKgwqDCoCBydW5fZmlvX29uX3NlcSAiJChpb2VuZ2luZSAicHN5bmMiKSIgLS1pb2RlcHRoPTEg
LS1ydz13cml0ZcKgwqDCoMKgwqDCoMKgwqBcDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCAtLXNpemU9JHNpemUgLS1pb19zaXplPSRpb19zaXplIC0tYnM9JGJzwqDCoMKg
wqDCoFwNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgID4+ICIke2xvZ2Zp
bGV9LiR7dGVzdF9udW1iZXJ9IiAyPiYxIHx8IHJldHVybiAkPw0KPiAtwqDCoMKgIGNoZWNrX3dy
aXR0ZW4gJCgoKGlvX3NpemUgKyBicyAtIDEpIC8gYnMgKiBicykpIHx8IHJldHVybiAkPw0KPiAr
wqDCoMKgIGNoZWNrX3dyaXR0ZW4gJCgoaW9fc2l6ZSAvIGJzICogYnMpKSB8fCByZXR1cm4gJD8N
Cj4gwqB9DQo+IMKgDQo+IMKgIyBXcml0ZSB0byBzZXF1ZW50aWFsIHpvbmVzIHdpdGggYSBibG9j
ayBzaXplIHRoYXQgaXMgbm90IGEgZGl2aXNvciBvZiB0aGUNCg0K
