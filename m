Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0611C7EE25
	for <fio@archiver.kernel.org>; Sat, 10 Jun 2023 00:10:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbjFJAKS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjFJAKR (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 9 Jun 2023 20:10:17 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2646335B1
        for <fio@vger.kernel.org>; Fri,  9 Jun 2023 17:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686355815; x=1717891815;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=msiZkN9gDYlTiGhVcL2JTzWJXUtOYH7jiPc2IBDk5zw=;
  b=VlcfygVHJPNY4td75lcbeSc2tYoCRs5z/oZ1wjKFb/xnc+GaDqB1TP5W
   41ZL4vQaTzbR75v9liJzctH47ik1LTNOPK3ttH2eL9P5Qu9UlPQta0/0g
   bU5SuQcA1HMPHyoZwBQo6DySRiUpSSkPFsdDXkatwBBDifXLWtuPG88LP
   eLATDJ49rakqfHE+Hvhb0b2O3g5vSJGqKI6UBCI2WlIBDiV2S9lyWZr5I
   C+X86yEAx1jNOVhesOrTcI1Xo2AFkr5QK2rFww710gHBHHMxJbS61SpPm
   bY4t7vNBk2DTrS/xkIAiI2m1y+HqxO6xWBvQuSjUK4ckTL+n6HxLO+AjN
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,230,1681142400"; 
   d="scan'208";a="346636759"
Received: from mail-sn1nam02lp2049.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.49])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jun 2023 08:10:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ABNenNH0fBljkNFIN8xxSAm+PVAFmk1sq6rXT98Oouwop8ZNOsLIloroj1Hu9o+DQRU0rJsk6D+j3Cgjq/YU0Hfepd69/Q/859cv3V34r6lQI7fIe1HWfPnss4gTh+1LtewiwjCnVmF9QoCV6AxycFt0EbFcPi0QQk3F0OMM58Enkdq97I1P9s/iR+k7hYjdh2JddsHffjRPp5m827XZdWExcudiYdF4YRjASFmZYMex+JSmNkxgBCZvxSQHg97M9GUUCkwUGEU0Iq27fjOMWLRA0LeQvZi5m29pkQJhc7IRHpr/UD8YUAjRcyXUW94o/fr+I2VJAHHdf5yQK8uhsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=msiZkN9gDYlTiGhVcL2JTzWJXUtOYH7jiPc2IBDk5zw=;
 b=lXShsOd+8mU78Gnl5I9hB8k1ukR1RqXDLGlsBpNWdcvRZ6n9/HQgd67ZRJUMqxHi3KgSSigsHpCKSuAJw1eB6NxiGSIV3PoCDB95oTXLSus0kgeg4DnQ0ku/sn0uKWjyHqVRJmsp4xhhwwPkopStxLxCn7qWLyKfGgTe3DgjTBzhQbGNaEhv8WjW0MQhT+s4Tttdq5ueuVDFfyEdfa341KT/QbJXunrnpa+GCl2zIzCRElZwwJHzLhJpDgFG5wv5bhsIUmykCqs/MnJyqO0OITXulMCF/MbyDPgoI+R9ChfX2UB5UOm0b40kLXfHEu5ZNwT8SKVrYl1TPbYmnixOHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=msiZkN9gDYlTiGhVcL2JTzWJXUtOYH7jiPc2IBDk5zw=;
 b=u+uCLYtW/XmZf81YbrgW90r+yhUMijEAzYRgK10AeKcGnNGlzFHMocYLJX32DX95xP0M67b7o4s3LoPA2ONzuQTJWIJ0vvPSwCVLTsWiJJkdVqOnwOINEmMKJBoHoM/s5oQYgOg7RdNb5LSAhmelRqcGDS+t1hyHd321bhHBEaI=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 SJ0PR04MB8359.namprd04.prod.outlook.com (2603:10b6:a03:3d5::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.33; Sat, 10 Jun 2023 00:10:12 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::eb0e:1bef:f266:eceb]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::eb0e:1bef:f266:eceb%3]) with mapi id 15.20.6455.028; Sat, 10 Jun 2023
 00:10:11 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Vincent Fu <vincentfu@gmail.com>
CC:     Jens Axboe <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: Re: [PATCH v2 0/7] zbd: clean up code and fix bugs for open zones
 accounting
Thread-Topic: [PATCH v2 0/7] zbd: clean up code and fix bugs for open zones
 accounting
Thread-Index: AQHZmde69Xc9uJtXGUavR8x6E2eyt6+BPziAgAAGyACAAIXngIAAspWAgACtkoA=
Date:   Sat, 10 Jun 2023 00:10:11 +0000
Message-ID: <gwk7twrqx3hcfmyat6m57virk553s46p6efuowd3eayag662oc@iyy57fioim7a>
References: <20230608070608.1256970-1-shinichiro.kawasaki@wdc.com>
 <be2ca491-c88d-0db9-f7d4-ecf71d485845@gmail.com>
 <c89d540c-cfb6-2830-6e3f-d16d2d577bd1@kernel.dk>
 <cpjjghwm3pzoxvrr2bq2o3an4cpukwgjmqhgz52cb4cgi5u6ps@yv6jpi4lve5f>
 <5271f7bf-a694-70e5-7cda-ec067b16b45b@gmail.com>
In-Reply-To: <5271f7bf-a694-70e5-7cda-ec067b16b45b@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|SJ0PR04MB8359:EE_
x-ms-office365-filtering-correlation-id: 8dbae3c7-e307-44cd-3687-08db69470ee8
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TU55D7Kh5YYzSOSJvj9VHIINgElDat+jqEL1GHaSrpzwZRLUJrY0LwojzfhOlZuBsNGLjb+mW+KSG5p+fHgDRz2HRopmD2l0lTFopJp/I7Q5nW6NPlgYKRJpuLEJ8wKHACFkKW05bfyvdvMJR6qf50Wk4Tq3r6f/DMlqaDkKpizkXL0eyoDLJh7ldoAPUFkbJBpUIoW5tsUAnAniQcRFe1zVRqFxSeaKHn8BLjdE++TrXWjNeAnZTt5CcFcZanmtjTkEh9BybTPyfzI356yQwl8kPfPuJyD+9r2+hB41ixag8P6QCsUDONs23MeNLJRnSLXkPMB0pu+jzUHOcEEOb4J20amoi1N1B7TIP7lONVQz9MzP5IYPDw3H1irNvjVi/ToIBZoMMg+jw1eYsQ0dLMcEnGAx9JWKmPKuSMTVefV0YPk0uXknX3+aTJaAIPNKp5wiqoYFGNoSoV0Yf0JnsaC3MwXw+s5tnBFSS6G0kXxgi3Ysd40QCXLh94rHB1Ys+Y60/ysJiJGlIgQfTSpB8biWneI37OMumWV1XRYnHVtWRmmr9dcEgX41Z9N5NfhpLbfn8X7wcicfv9TFSBxZF2Co5VDVr84QpikZh+RqcSS4wX61kaK2o32xsPddtgnP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(366004)(136003)(396003)(376002)(39860400002)(346002)(451199021)(2906002)(478600001)(6486002)(71200400001)(558084003)(38070700005)(86362001)(9686003)(26005)(6512007)(38100700002)(122000001)(82960400001)(6506007)(186003)(33716001)(5660300002)(64756008)(316002)(8676002)(8936002)(66946007)(66476007)(6916009)(66556008)(66446008)(4326008)(76116006)(91956017)(44832011)(54906003)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?S/4uuBdyiLOfhb/FEfsAI4m8SkEn0BNKWUWBAqWQjulplX/2ZNWRyFfRlhWC?=
 =?us-ascii?Q?dYddDXBUOH37Y9NcLuB1+my7X25W6p0/mC0sFify/EV6075JB3DXgv7KPL8g?=
 =?us-ascii?Q?Ks2K+XrBdbC8rd+TeiM05R1zRZVejwybUb7QtYnM43IjcBHPKnDaX59a4a+r?=
 =?us-ascii?Q?m3f17ZsKwJYTpv1VBqP8JwzQTV6r7dwD38DbbhN8GHmLkL7xgrs9VinRj6Y3?=
 =?us-ascii?Q?OjzF2ki1aIhcRAuAuewh44c5A5aR5Exn8BcvfzHaPzglEJmyj4Ea0VheZMqz?=
 =?us-ascii?Q?p1ZxJvjsrIzrheMLx5gFG8IbCj3qomdvSiBW5r+YwCmHdSV8JZoOtvbCbBsT?=
 =?us-ascii?Q?P3oeJXMgWfrO+yF5gbyl+/bsFUD5D8sCjKyFWKQ7oW/zZUnvyHU1GVJ5vaaV?=
 =?us-ascii?Q?UrkWIMmLfVaoyQ0blmEA153a7ldJO22n3tMB6ACYciu1QMO9BUOtWQU5mDhb?=
 =?us-ascii?Q?rFx8z04CPppbxaMfGbDlh+yegxTFhBFiWNnWWUqXUd8o88MqYED0yBm/RrWV?=
 =?us-ascii?Q?vjJusDa4gh0Esr7Cevn71KScAb2bFEER/vBHvKiHsmKwcvGhzukDQzSdFz3y?=
 =?us-ascii?Q?5aIDuY1sAlFQicIBfD642XsR/q5WtWjv8DJYOsZFbsiC4vf0gfSB0g0eSO2P?=
 =?us-ascii?Q?IzjPuzG5Em1pvKIw6xY8ZFeudGxiQ/WxmW5+3N+H7UqvXxUwLlKXPaVWX2om?=
 =?us-ascii?Q?CSmU4qs/RZgPWkC53o84sSOwYdTLoi5eCiYNxo0/YPZ0KjPCaQDOu+3Fw7Nc?=
 =?us-ascii?Q?1uFjQACmpHJFqQYPXUSqnYiaLbcgVp/G75sPyTz3IG/TxBr0M9rBx5581yND?=
 =?us-ascii?Q?X41rRHV2biCcFmvL5DgJH+STdOPr9M7ZrTDgzma9zf3iMwjoJz8vnvqbiQLA?=
 =?us-ascii?Q?HtEbXYTP4NT1jqSjoRZPoggK8sxi9+6qcEOwLg/oX/Rx93L0IGJZviddu0WW?=
 =?us-ascii?Q?zXXqW+t+zEO3C6yvoTOq4PBdzWdMijHl5GP/mftsRZmGzUxtScNJ2WgttFGX?=
 =?us-ascii?Q?kW6knJ9T5GEFBcbFv3gV8/mOI9/+8/jiOCcESTKf5nJNAQtkU5NL9NDdRfMh?=
 =?us-ascii?Q?0YqHsQ50BI/qwlzECEtEYLLwUYlUmPcp8xO2Si/LN11ZypC4B0dNzWHolhlu?=
 =?us-ascii?Q?43zD5dqCLfaOjBG9sMQlb1n+y4n3KNKg+bEf9myBeF1bqqe1T7HCtrG5HZbm?=
 =?us-ascii?Q?zJoJ8+681olGaL1c1OkY3CkPuLImhaerj+XhZ2TwZpwUtbVAA9xFzNnrt0Eq?=
 =?us-ascii?Q?+3cu9JPh1vGAtt1hgAC8xEzwOBOrf1bZLj8TQ361w/JWKJrNleqjEDKTVr49?=
 =?us-ascii?Q?jy+oKv1mXoBnJx4+QjQQDDQw1xrPx8wbw4NhDUvjntZd0sKNo5uduDvS1xFe?=
 =?us-ascii?Q?rqYJWtyUr83fJxLGDj4CBHwfmAGGDtVvKV/1xFcwHiY6yHdXmsw2HwnluW66?=
 =?us-ascii?Q?M5Rnk8zoaF/N2FBYPhbsDdxXGaa8sRTjjOuEUnmVgL2qnCt20i8ksEM+zqo4?=
 =?us-ascii?Q?GuYGJ5T6BJl8jS6BSDc7O9bockXw8bSIq+IQiFSbO8uS5bCBZ26ElDngW+B/?=
 =?us-ascii?Q?jlTqAT+29HITWt/G722lUzfSCriTFm6irpoRu5+0tHp0O0OScnc93+5c7lBl?=
 =?us-ascii?Q?2wWsc+G7OkfELZKPVOsqrWo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2410EF9E8FB83240910D756608814C41@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: AsTe6eiY/R8AtOA6UhwRp7p/WFfj41vg92BNlJQJ2vGNNbrvo4ddqxjPjqxQnA7FvQJA+TslZLVpNg2I37/2Fi3A03tBRgjoQitt+voZJvRfL1Mjim+i8VV2QhBuueeLaLf1X7PGo+e/X0Ty9rxbqk1KyXWHsPhMukUTHc/PFDjHCVbQXIwlTe+FkwF/WsM79aJXh6fOpNhzBONC71UmVLk3R/PvsvJ/uHL8HT8pq0mI4wzjnvFmkM409dkZ3K2nH8/Xd12Ci4sRPIe8dv/cLADP0kg+Az8NchtU5sAXBzPBW9DscRXEdPgKc2Ezy1oz7xZFW/1GeX+YVz7BG5kg6pqkcnbg8G1Gu4X/vY06FwljehqixOnAlJxnJhhGoPXWjxf/9XrFM2HVy7keMpP546/fon8WdFQk7HXZz8ZzpFnzL7/riTrHTQvrhpddaHh9Yru6ObZgXIZwyWDVqb0qg5GeQsak3iEBS+ItGvqK/xbg0/ik+SyNU+Z2hJqBhmHx75cx51Y/65Mqacv8qqjobtdi0wrSQXqxLnzZfZPd7nZzM54L1etU3WL3rb75Imngs+wk4T+TKxyZAsBCe3ZYepBcd6DuVGcoGwCRsMNTOPlJPidehI+URDIygkpPPiFKm/hOKSlSUCHo7jtKiUWD4W2U+6VGZhLfbO+Dy/QkdZv+A/wK3DapIVXUxCYsQ8pK9E07Rumo9rZo1yrvL2gyNtprRjnevzZZtTPNKzjNzcn4rSGb/aPzMxB6DeWC3b+lG7Qjp/JEMvrgz1BOk4/FlniIkAZrxFfhU8Qf7KQsH/0xM9erevKCZf+3mfiLiAUFQlAuvJDoBI/xkrQDesfgHOwoxu5bwKrHIUJG4d5M6Mc=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dbae3c7-e307-44cd-3687-08db69470ee8
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2023 00:10:11.6267
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0U6wE8igsD44efTcOO7gcdrsLIVy8gNEss8y2ZCrJ1ZRcG2j5i3LFQ58MowgIighlFzN4rccqMo4vQvOAfsdEwofJYUbA8Vfee5SsB6iaBM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB8359
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Jun 09, 2023 / 09:48, Vincent Fu wrote:
[...]
> Shin'ichiro, yes the above patch silences the Coverity complaint. Would y=
ou
> send a patch for me to apply?

Thanks Vincent. Sure, I've sent it out.=
