Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E5FEECAAA1
	for <fio@archiver.kernel.org>; Fri, 28 Oct 2022 02:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235514AbiJ1CLf (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Oct 2022 22:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235708AbiJ1CLb (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Oct 2022 22:11:31 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90A0A5999
        for <fio@vger.kernel.org>; Thu, 27 Oct 2022 19:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666923087; x=1698459087;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=sRPb5Iy9iZCqNdqfnkKhhH/aS+YQXroFuLNlyB5Fumw=;
  b=i/n0qKxO7gRlJLzAawpLvwVBKQjGKNDu/lCu+lsC7wCCwAIgpLarCDFR
   lXYWIeeLPml2lUMOqMtxG3MM0cnqjGD7GzGCIChhmvzh7E+WP+oLfMUSS
   ZI9qp2coxuAgM2rlf6HJvxp4RPWnUQXPN1OgoO8xTMrc9aF/p1Oj60d8M
   PNOE67pwqpUAy+1G0lPs/txM0hM3VZ+R+W/lJQlIfjZeS+WDIGe9Uq2Ce
   92g39qjppVBjED3a3z6SKjmGi3DZFWvjWGPCemkxdH7FM2ynMDpNP9z3v
   7mGck/jjUXLHf+4ROm8OQAgAr8mEDbVeyRy3dIFacqWMMKSDYqf5N3c9t
   A==;
X-IronPort-AV: E=Sophos;i="5.95,219,1661788800"; 
   d="scan'208";a="214930680"
Received: from mail-dm6nam12lp2172.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.172])
  by ob1.hgst.iphmx.com with ESMTP; 28 Oct 2022 10:11:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z4yjZXCB/+VVPQ0UKBW7BAf68L79eTDzDw/UVRTqzC9DiY+QaZU3Yy4JCpQUazx1zZ4AZvYSWK7tCopizf3+SfoQFovCTqea9ofhuhEyQEA36AZvF4CJ/bBpLDg9crmXVkkjDBoegprvCxvLbpKtMWtB+AejHXFuzvhIRpizKWiEPRtaSBXU5qIhaNlLyfl6xYKcBxtxcStvvv1p7h7Vl9qfqSJHKLlw7JmsEvuMEUg8R1g5a+Sdk/R9G0Gv0UrqdVyL6QMWXNQYituBRwp+71pZAsCrdSlRRAwxp+Z1EMXAzJhJtIeeB/nnNHbn9AR3uO74FEuvtN98Utvec9AgIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sRPb5Iy9iZCqNdqfnkKhhH/aS+YQXroFuLNlyB5Fumw=;
 b=GSYcy25GmWSwSQrW/ZND0pnNb18b8exYrbAdmaSUeAgE5WNAK0T+WYudXI/n4sS/1rFx1XHNUkYqp8D1Qq5wW3uA05i36v8lBaJNlLbk4MIUBFTPOAtaA8NhfImZxE68S4rRsksq4mfRrqPhhL6MzArR/YUvDdpjF+MUpswbm8nbx4LKD4OrhIrprZwPw2JFCZSdlX7EeSuoySBPGTuId83QDRZyDmvBWEEryiSeKUeWnT9LD0m3x64tgrxjpq1xDUgD3nel9Zt1wWNZnFe8MLxOyk2+A0EL1/2u/ludbNv1j3zFtnBw4JIMtKztzuOUhAOXUjm1KexeErP5YVGfyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sRPb5Iy9iZCqNdqfnkKhhH/aS+YQXroFuLNlyB5Fumw=;
 b=ujH/mWH/hRMNi+zwNe+YNjQ3F3fYc3TgYADNlc7gCEvmoEn8n/58wr9n4EypDHDtufIQGGC9OOeSHyp/FItSWzm39mLmGFpWv9AQkKt0VG2Q2LCbzQ3+hxOjo+KKDXvg/LrNfIjZhASdX4rwbwL02RsvOdaDzDen4nBmrb6s8ag=
Received: from MN2PR04MB5951.namprd04.prod.outlook.com (2603:10b6:208:3f::13)
 by MWHPR0401MB3548.namprd04.prod.outlook.com (2603:10b6:301:79::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Fri, 28 Oct
 2022 02:11:24 +0000
Received: from MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::51df:fdd7:7c49:12ee]) by MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::51df:fdd7:7c49:12ee%5]) with mapi id 15.20.5723.032; Fri, 28 Oct 2022
 02:11:23 +0000
From:   Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "vincentfu@gmail.com" <vincentfu@gmail.com>
CC:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH v2 03/13] zbd: add zbd_zone_remainder() helper function
Thread-Topic: [PATCH v2 03/13] zbd: add zbd_zone_remainder() helper function
Thread-Index: AQHY6cmcRC81BuOGX06VzvMR5an6Z64jEZOA
Date:   Fri, 28 Oct 2022 02:11:23 +0000
Message-ID: <75f4b490287caa45a46af0a31db9608426c767c5.camel@wdc.com>
References: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
         <20221027060139.952508-4-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20221027060139.952508-4-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB5951:EE_|MWHPR0401MB3548:EE_
x-ms-office365-filtering-correlation-id: 1fadc96c-4dbc-42a4-ced5-08dab889b67f
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G340eOC5f/CH4PWHD7mQeAD6IdzMp9/FvxaK+/+X0sYtU1nv65Sw/+diKO127bQL58F5Mhk0yLrF0ztLCmThuhw6NSMwaCNowTbdpeX2sHQUoelOrU/1uZtg1UUpcC43j6L4eAmRZL4nexv78RjWgTIGZauFzWhoUAdi1hWpaY/ILHx9Dif5d+v4f2KEiRrRRbfl6PgUYhEcVm8ZQt4aIZhIjOs0z9r3+oACHkYe0vSLcl75bfzO+vuSBe4I0VlLDlZwV3D8N0RFWcwCsw98OOaTod1pWk4xTfwfbTXQj67hn/QTNwzOT8kTTZSmLL/pCrgnYngvgy1uTQQPsQ95ZqwnU/TU/2kAWHNm6/pymx74PGeEO3ic8LQiboAUdO6kc3ExiCcac9axoOIqFJ6+Hw1r5PZk1o1H+pBO+YyBoqreB4y52wH4y8yqhhfqvGNmGEuUazi7Fd4YPvsqOwjtImPFALLEMRbJmvSIgPyJMuDjqIQtjUz6xcZVHIa/9hp5BBwD6Sxu1elE1yRWmNJ2G6sDIc//K5+lk8jaXH/zx1KDfbkFgorpoSyarxv2GqqTJNgy8iy95O0+e2dWYjT5DkyMa7G8r1YTctPvrv4x02+uZWXjJ2g6xiOUiMEwfI8wYULtbUklOzldeqrK1W9jQXDRekcUbLlALQrPdJx969Qf1/I3rH5sk+bkyhqhDIewJUcA98wfndxMM+6uohbvKSsUVJxgJuPYLRKXwmNPlwfEGStj6y+rpGi4iqmbkC90gHSBdMzJfQpkuE3/K3qpXQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB5951.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(346002)(376002)(39860400002)(136003)(451199015)(8936002)(6512007)(5660300002)(6506007)(26005)(186003)(82960400001)(122000001)(2616005)(4001150100001)(38100700002)(2906002)(36756003)(41300700001)(38070700005)(83380400001)(478600001)(86362001)(316002)(64756008)(8676002)(6486002)(54906003)(66946007)(76116006)(66556008)(66446008)(66476007)(91956017)(110136005)(71200400001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QnJESkY1Y0VaWmlGK1pYeFVnVXJ0eC9iVk02YzJrTlR3VzEzT3hCcWp4WVN2?=
 =?utf-8?B?WU9XTTUyQnZRQ2dEaU9XVWliMlNGczZ6a3NTd2E5Z09uUmxPMHl6YnNnS0pU?=
 =?utf-8?B?bXlocHA0NDZFdGp3SXdkeWRkaEdlVitCRkIreTdZc0tjUkRNdFpIRFZpVUta?=
 =?utf-8?B?cFJWcmt4UStPWXZRQ2xYNlJYTzh3SnlnQk9rVlNaTHZJb0gzbDQrSzNya0t5?=
 =?utf-8?B?ckI3SVZrQXRXdjdpbEVRS0VBaURpcGlyb0d4eWVrbVkrK2JkbWZScGdNM2Jx?=
 =?utf-8?B?dzZPbVo2OEhLdC9PQVVoTlZCcnNjT0xwazRqeVRObzJ3YnF5TitkWjNjbmt1?=
 =?utf-8?B?MFk2RmJXWGFoWWh6dUFISlhKUHBGaUI2d1pGZTgxVUkvdFhqTjY4UjM0UUpT?=
 =?utf-8?B?b0VoaUs5SlZKUHhIZzh5b3lnalRQSmpTcmZFOWRoa1U3YkNaZjRyYUtPWGta?=
 =?utf-8?B?L0JFZVQzcElIRlRnNStnYWtDV1JSdS9EYjN6ZnpjSm9zTTF5VUtCb2ZqNHVX?=
 =?utf-8?B?OXUyMVRFUDF5KzlnR1FkdnVSMUNkSXVSQkp6dXFDa0pWYThBRjk1SmFIaFAy?=
 =?utf-8?B?WVFCdVN0bUxCOGVsOUhENGd5QkhGWnZUMW0yeXVQdG42THVkYUl4NTRnWmhk?=
 =?utf-8?B?bFJURCtrQkZrRXJLT0ZKUTdRWXgvNnZwVHRLbDMrQVRSajlqUmcvRm8xTUtH?=
 =?utf-8?B?Vm0wUy9mbWRkRzlUYTgxQ1VqVC95ZzFaMjJqY3UwaXd3SHpFbEYrVmdCWkty?=
 =?utf-8?B?bys3em42eUI2b3paZGNpbkV1MXNQdXR5SytRanlUQWlPdEdURGxMQUU3TFFZ?=
 =?utf-8?B?UEh4cG85d3VOYlJZWjNUbHRUOTZlNkJYZEZwQWdZYjNvdVRsQkRQdkF1RGxX?=
 =?utf-8?B?ZUl6azhOcnE3ajhkcW1OZGRtTlZtVmh2cUw5NFhhOGhzcU1uT3ZVbjBaUyt2?=
 =?utf-8?B?ajN0SlVMbG5MaXZkUWdYbElTOHFYVlVUVlJwc3ptMkphQmtqZjBrUzlFM2Uv?=
 =?utf-8?B?S3dzbnE5ZUZlSjFhcFlBV0s5eGVmNnBaa2RwclF3NlpuZ2FibFAzVDcwalRQ?=
 =?utf-8?B?NCswVnBZWlhDS2llQ3AyZzZSOElUeHBIRUFtejZQVldHNjlOdTRiK05Yamlj?=
 =?utf-8?B?R1JyQzFTNDNPcmtNMXpyZExjQnpFNEVUWjExYU1qZG92SVA2VmFBT0lHQm1X?=
 =?utf-8?B?dlhlRTdCYTZMRHBXNGhCZVJ1UUQ2ckZESGI2a3lqWnk3NmNBeTMreWJaL2NW?=
 =?utf-8?B?cWk0YWhhVXhqUlJHZWFpUmtGSGlCZWFubjAzNDdxLzhNTWRRb0oycTdhRWxS?=
 =?utf-8?B?Q3A5ZE1GaDF5aXBSZDF0anAzdGRXM3RxRUVNKzBCYUgwWlFvS1V0eElwTnZW?=
 =?utf-8?B?ZlFtakNDMEYxVWFtTFlwelludkhySmdMMlIzR1E3Tm52aGpEd0VJNGQvRnBN?=
 =?utf-8?B?M1ozMTRIR2tReEhvOXFsVlBJQTdkTEtVSUlrcVRQQzVTTHU0QWg1dmtSN1Ew?=
 =?utf-8?B?N05xY0VDOU5mVmhHUlVzMWRqMzQybnVXZXJnQ3ZKcGNvaXlFK0JoMlRDWU1S?=
 =?utf-8?B?UUJDV25tc0ZKN0VUaTlJbStkSG5yMk9CbTF1Z3IzTHlIeTdmRUxKMTJzaWVO?=
 =?utf-8?B?alNGaFVxNzgrTG1EVHVBTmUyQjFqdCt0U1VTOEFDdEE4eEM1YkRRUXpnOHl3?=
 =?utf-8?B?SThmWk13TU1Bd3JobzZMcXlja0RZeDIzL3Jsb2QwZzB4Q1RZT05WZXZCSENp?=
 =?utf-8?B?Z1NqdVYralZtcEJYM093bldUY1pLQ1ZBQVZNYW5nOEQ5LzdkNk1SUkR6UE5G?=
 =?utf-8?B?UFJDMnZoZnFncU90K1BYQ1dVQ2tiZXpHY0FUM1RYRlY3Ump1aTFORVFmVFVL?=
 =?utf-8?B?QnovcFJzZ253TjZ4TnF2bkIxMVFyd0hXR2ZvRExjZGkyKzFUUWFaTzI0dFFK?=
 =?utf-8?B?bGhMTFBOOXZYalV1dG5aY2NOdnM0TTVmZ1pXcS9PMUxTMlNqdzY1cS9sbGZs?=
 =?utf-8?B?Wk5rR29mdnZhVE5HZitGYkxRREZEWURwTllDbU95ZjR2K0xIZENJUllEaFor?=
 =?utf-8?B?M0wyaWszbHo1V1FVQ3ZhL3lCaHZoODNHeXZIeU14aDNrK05kckY4blc4SmxK?=
 =?utf-8?B?UHBBSDVFTHhCMVp6ekpnOGxQR2p5WlBINzhoZWh5VmxrL0dXVkkwUjc3RGpt?=
 =?utf-8?B?dFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <05E18ACE3AEC5D4E951456C8E15B7337@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB5951.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fadc96c-4dbc-42a4-ced5-08dab889b67f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 02:11:23.7581
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N60JcnxciNa6wO4WjC/FLqFYlBlHqL/IrH4O+GXsqWWO8qZcbEveFLYK7Z/5gcJjNPOGwRSh0W9ia6PlGQ4xiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0401MB3548
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

T24gVGh1LCAyMDIyLTEwLTI3IGF0IDE1OjAxICswOTAwLCBTaGluJ2ljaGlybyBLYXdhc2FraSB3
cm90ZToKPiBBZGQgdGhlIGhlbHBlciBmdW5jdGlvbiB6YmRfem9uZV9yZW1haW5kZXIoKSwgd2hp
Y2ggcmV0dXJucyBieXRlcyBjYW4gYmUKPiB3cml0dGVuIHRvIHRoZSB6b25lLiBVc2UgdGhpcyBm
dW5jdGlvbiB0byBpbXByb3ZlIHJlYWRhYmlsaXR5LiBJdCB3aWxsCj4gCgpOaXQ6IHRoZSAiYnl0
ZXMgY2FuIGJlIHdyaXR0ZW4gdG8gdGhlIHpvbmUiIHBhcnQgY291bGQgYmUgcGhyYXNlZCBhIGJp
dCBiZXR0ZXIgYnkKc2F5aW5nICJ0aGUgbnVtYmVyIG9mIGJ5dGVzIHRoYXQgYXJlIHN0aWxsIGF2
YWlsYWJsZSBmb3Igd3JpdGluZyBiZWZvcmUgdGhlIHpvbmUKZ2V0cyBmdWxsIiBpbnN0ZWFkLgoK
Cj4gYWxzbyBiZSB1c2VkIGluIHRoZSBmb2xsb3dpbmcgcGF0Y2guCj4gCj4gU2lnbmVkLW9mZi1i
eTogU2hpbidpY2hpcm8gS2F3YXNha2kgPHNoaW5pY2hpcm8ua2F3YXNha2lAd2RjLmNvbT4KPiAt
LS0KPiDCoHpiZC5jIHwgMjEgKysrKysrKysrKysrKysrKy0tLS0tCj4gwqAxIGZpbGUgY2hhbmdl
ZCwgMTYgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0tZ2l0IGEvemJk
LmMgYi96YmQuYwo+IGluZGV4IDYyN2ZiOTY4Li4zZTljNjZkOSAxMDA2NDQKPiAtLS0gYS96YmQu
Ywo+ICsrKyBiL3piZC5jCj4gQEAgLTcwLDYgKzcwLDE4IEBAIHN0YXRpYyBpbmxpbmUgdWludDY0
X3QgemJkX3pvbmVfY2FwYWNpdHlfZW5kKGNvbnN0IHN0cnVjdAo+IGZpb196b25lX2luZm8gKnop
Cj4gwqDCoMKgwqDCoMKgwqDCoHJldHVybiB6LT5zdGFydCArIHotPmNhcGFjaXR5Owo+IMKgfQo+
IMKgCj4gKy8qKgo+ICsgKiB6YmRfem9uZV9yZW1haW5kZXIgLSBSZXR1cm4gYnl0ZXMgY2FuIGJl
IHdyaXR0ZW4gdG8gdGhlIHpvbmUuCj4gKyAqIEB6OiB6b25lIGluZm8gcG9pbnRlci4KPiArICov
Cj4gK3N0YXRpYyBpbmxpbmUgdWludDY0X3QgemJkX3pvbmVfcmVtYWluZGVyKHN0cnVjdCBmaW9f
em9uZV9pbmZvICp6KQo+ICt7Cj4gK8KgwqDCoMKgwqDCoMKgaWYgKHotPndwID49IHpiZF96b25l
X2NhcGFjaXR5X2VuZCh6KSkKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJu
IDA7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoHJldHVybiB6YmRfem9uZV9jYXBhY2l0eV9lbmQoeikg
LSB6LT53cDsKPiArfQo+ICsKPiDCoC8qKgo+IMKgICogemJkX3pvbmVfZnVsbCAtIHZlcmlmeSB3
aGV0aGVyIGEgbWluaW11bSBudW1iZXIgb2YgYnl0ZXMgcmVtYWluIGluIGEgem9uZQo+IMKgICog
QGY6IGZpbGUgcG9pbnRlci4KPiBAQCAtODMsOCArOTUsNyBAQCBzdGF0aWMgYm9vbCB6YmRfem9u
ZV9mdWxsKGNvbnN0IHN0cnVjdCBmaW9fZmlsZSAqZiwgc3RydWN0Cj4gZmlvX3pvbmVfaW5mbyAq
eiwKPiDCoHsKPiDCoMKgwqDCoMKgwqDCoMKgYXNzZXJ0KChyZXF1aXJlZCAmIDUxMSkgPT0gMCk7
Cj4gwqAKPiAtwqDCoMKgwqDCoMKgwqByZXR1cm4gei0+aGFzX3dwICYmCj4gLcKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoHotPndwICsgcmVxdWlyZWQgPiB6YmRfem9uZV9jYXBhY2l0eV9l
bmQoeik7Cj4gK8KgwqDCoMKgwqDCoMKgcmV0dXJuIHotPmhhc193cCAmJiByZXF1aXJlZCA+IHpi
ZF96b25lX3JlbWFpbmRlcih6KTsKPiDCoH0KPiDCoAo+IMKgc3RhdGljIHZvaWQgem9uZV9sb2Nr
KHN0cnVjdCB0aHJlYWRfZGF0YSAqdGQsIGNvbnN0IHN0cnVjdCBmaW9fZmlsZSAqZiwKPiBAQCAt
NDQwLDcgKzQ1MSw3IEBAIHN0YXRpYyBib29sIHpiZF9vcGVuX3pvbmUoc3RydWN0IHRocmVhZF9k
YXRhICp0ZCwgY29uc3QKPiBzdHJ1Y3QgZmlvX2ZpbGUgKmYsCj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgKiBhbHJlYWR5IGluLWZsaWdodCwgaGFuZGxlIGl0IGFzIGEgZnVsbCB6
b25lIGluc3RlYWQgb2YgYW4KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIG9w
ZW4gem9uZS4KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqLwo+IC3CoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoei0+d3AgPj0gemJkX3pvbmVfY2FwYWNpdHlfZW5k
KHopKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoIXpiZF96b25lX3JlbWFp
bmRlcih6KSkKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqByZXMgPSBmYWxzZTsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gb3V0
Owo+IMKgwqDCoMKgwqDCoMKgwqB9Cj4gQEAgLTEzNjgsNyArMTM3OSw3IEBAIGZvdW5kX2NhbmRp
ZGF0ZV96b25lOgo+IMKgwqDCoMKgwqDCoMKgwqAvKiBCb3RoIHotPm11dGV4IGFuZCB6YmRpLT5t
dXRleCBhcmUgaGVsZC4gKi8KPiDCoAo+IMKgZXhhbWluZV96b25lOgo+IC3CoMKgwqDCoMKgwqDC
oGlmICh6LT53cCArIG1pbl9icyA8PSB6YmRfem9uZV9jYXBhY2l0eV9lbmQoeikpIHsKPiArwqDC
oMKgwqDCoMKgwqBpZiAoemJkX3pvbmVfcmVtYWluZGVyKHopID49IG1pbl9icykgewo+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcHRocmVhZF9tdXRleF91bmxvY2soJnpiZGktPm11
dGV4KTsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gb3V0Owo+IMKgwqDC
oMKgwqDCoMKgwqB9Cj4gQEAgLTE0MzMsNyArMTQ0NCw3IEBAIHJldHJ5Ogo+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgeiA9IHpiZF9nZXRfem9uZShmLCB6b25lX2lkeCk7Cj4gwqAK
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHpvbmVfbG9jayh0ZCwgZiwgeik7Cj4g
LcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmICh6LT53cCArIG1pbl9icyA8PSB6YmRf
em9uZV9jYXBhY2l0eV9lbmQoeikpCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlm
ICh6YmRfem9uZV9yZW1haW5kZXIoeikgPj0gbWluX2JzKQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gb3V0Owo+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgcHRocmVhZF9tdXRleF9sb2NrKCZ6YmRpLT5tdXRleCk7Cj4gwqDCoMKg
wqDCoMKgwqDCoH0KCg==
