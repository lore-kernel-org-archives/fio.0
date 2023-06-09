Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 116A8C7EE25
	for <fio@archiver.kernel.org>; Fri,  9 Jun 2023 03:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbjFIDKF (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 8 Jun 2023 23:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237837AbjFIDJ4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 8 Jun 2023 23:09:56 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB91830C3
        for <fio@vger.kernel.org>; Thu,  8 Jun 2023 20:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686280194; x=1717816194;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=FISBDC9h2KAIRNEvfiG2Z7uxO8zzj0GHvGfm/Ki1BNM=;
  b=kHt8UxJBqKt9phCSsx9Gjl3wLjd7py5gr9f8e1nA0ZYecotGTb6Bmy1v
   Lbt7kMhk5RPKdKqqpp7LETr1n9Gfs+XgDlaGmNU14ZTnh7bxnDhRmBf0y
   Sjx4oAcSsBxDpvsVNonv6GDY6Dsnb1Ww17CUQACsKUKYTX86LII7rbKAM
   RNolXvOBrYn5ksivdu8NenLFAYc08BjSRXJ95bl5Cng5bGe98tMu5/J/6
   gBrarixP5c2UbW8YDXgHrOzWR2Jp7tTJWP4O+u7vSnHazQRXXhwhFRSjT
   we2lAoPSADV00zU9Bj3JE3g4Q2MO+FEXOUEoaHO4va+bO9aApqBFrHOTs
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,228,1681142400"; 
   d="scan'208";a="232411805"
Received: from mail-bn1nam02lp2045.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.45])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jun 2023 11:09:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BniO4BmvPbdu7Fg6lk4vAzhNZIBxhQPPoZwKAaZtyI19e/l4KVtfc8MCO4a9OESd8VIJ7/GK/m0bOj5AgnYkhs6fzG7nTXYN2KYLqgvyT2vLzRxqdqlkw5HT6jX2o9Ncz56zwnbMkf6SbSsy7LOiQfDhmUk1XMxticqxUKb1wyc6Nq8Wp/Yqa6GKEpka/1DOaHvUXXpkoP1VI5k/qxbcAeF1g8QBxB9xBYSYDtFpfeGL3sVof3EPW/5rBP0yYiHqKGApv7OuxK/MGjcYnvO0JJttoEojQLAdN+Ge/fDn/uMFXOyI6EH3LVV1w8ALbpguN7ak+QJzVkmiyxCSj5HYCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z+eLSuKW4o0j/YdYjoJxy62jOJUmXjmL6uWKiKlF27I=;
 b=G6QcbaJwZ6g4uEDGiHTlFFDaWHzFFq9UEIadd2Y3YY81HfdFcFmUZ22rHm2y5wgqk19z6TguieexerldKk5IuFdpbutKlwQtaM4R567+gQo1czRmGEWZG6dcr92VjvNsT6ijF0ZD0WaYUhLthA1kgPPPqd5xKYBklyKLolHt2t90EM2AZR/fK66mKDn0rcWSQYpVG6N1gmW7nSQ/jm3UV0K/EoHwqSVmI6j7WEarblGt3x5H2rZlpeiovLFcV+xk3BDjoAOWpB++GfJ+jOl5luVMBD6JCWlwu3ne4/nsrTmnNR7V3Q6A94GjNqP3BDwjYm1Ii7TG10ZjobiGGa91ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z+eLSuKW4o0j/YdYjoJxy62jOJUmXjmL6uWKiKlF27I=;
 b=tEpvtFveSpYykY5NAIcKQ70n2zlKQ9HDKITQi7uU7eRO94Wf0ebBYi9KdDM7GWBOfOoN5HWyKo5f6Doi77lgcU1Qr1i8nr/wHBJtLBJSYJCivJPCJyuh/raMMFcv4xzVLM34M+JJy8B3wVGjH/C5KT8a9XdGGMf88slg8QrZi4A=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 CO6PR04MB8377.namprd04.prod.outlook.com (2603:10b6:303:140::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Fri, 9 Jun
 2023 03:09:51 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::eb0e:1bef:f266:eceb]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::eb0e:1bef:f266:eceb%3]) with mapi id 15.20.6455.028; Fri, 9 Jun 2023
 03:09:51 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     Vincent Fu <vincentfu@gmail.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: Re: [PATCH v2 0/7] zbd: clean up code and fix bugs for open zones
 accounting
Thread-Topic: [PATCH v2 0/7] zbd: clean up code and fix bugs for open zones
 accounting
Thread-Index: AQHZmde69Xc9uJtXGUavR8x6E2eyt6+BPziAgAAGyACAAIXngA==
Date:   Fri, 9 Jun 2023 03:09:50 +0000
Message-ID: <cpjjghwm3pzoxvrr2bq2o3an4cpukwgjmqhgz52cb4cgi5u6ps@yv6jpi4lve5f>
References: <20230608070608.1256970-1-shinichiro.kawasaki@wdc.com>
 <be2ca491-c88d-0db9-f7d4-ecf71d485845@gmail.com>
 <c89d540c-cfb6-2830-6e3f-d16d2d577bd1@kernel.dk>
In-Reply-To: <c89d540c-cfb6-2830-6e3f-d16d2d577bd1@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|CO6PR04MB8377:EE_
x-ms-office365-filtering-correlation-id: 59325b71-60ed-42d3-e977-08db6896fd78
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W5rVrxhpRHuHCne9vOxcQjkl3ZYAKy87QM4Bo8UAVj0P3j2m6OynFLW3RmHw5DctSbw/ywJTVs9rubNW5/z8r/GkSky34T+mEp3gH5L872TzGBzVNC8fG5m52AY51kDZxiXBcpZfrlnRdiFIZ7fokEM7X7XukAMER14e9yGBkF3YnxKP3iJy9pFitsPJdoyRXv1j/RMV+g7SYOep1CO6gkN+/4f6KKAVTF0Y9TPA5sU7dnldArgpkGlb/rGLrEJjhLjYEBpfy3K45LdVRDjE9YwxmISPv+qx7yaTiHpGZH9g+8bIFZfMqUndEA34PTTQwWWdHSoVC7Ic/4rlzNpmNiduYpvhcJEENmbQNEM5zYWgk4n0qguNQcFsdngU+4Tg2zbsP97mAykaTGmJP9SrKMh0b1QGymdxN7jwKFLUL51bvS9Yr+4QwxMNmLIk+De2U5NOD2u11OqXP6960V9o6OHILLIrmDoNoXbIGBN9RbHjMgadokdGQvYhzBpmlRgPHVs5+D4uN2tRyBSJxv+qp3Sl3VUY0bpQb2U5ot9wPLdAMzUWloN0fwlpseTOXPfGUTWPMaYztQ7X7Mj2PSTAWu617HFdbVLckbGyEembwftvq2T8qv8Sa7r7L81T8sXs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(396003)(346002)(136003)(39860400002)(376002)(366004)(451199021)(9686003)(33716001)(186003)(26005)(6506007)(6512007)(6486002)(66446008)(4326008)(66946007)(6916009)(76116006)(122000001)(82960400001)(38100700002)(91956017)(71200400001)(478600001)(83380400001)(66556008)(8936002)(44832011)(5660300002)(86362001)(8676002)(2906002)(66476007)(64756008)(54906003)(38070700005)(41300700001)(15650500001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?etw9DiRRm8nblUXCslYRrmwzulUfBo9F4ZinUbN43JkAoH0kmEF8GSkJ3GOg?=
 =?us-ascii?Q?3pVEoUEs4Z4WIT/k7bYGrD2nUjsKLIotZ4B/rSwLMxjSdaLhia/WnlB9E/DZ?=
 =?us-ascii?Q?F9EKPHkq1fHvVDZShYRDyP14YM4BFXwfJegM5QG6xErdiRrwLO++LNS54n/O?=
 =?us-ascii?Q?CcRZSd2Je4FKYyMlo49I6GZ0QIwIudVx/un6NeuTdTlxFi39L4Om6Hn93n1e?=
 =?us-ascii?Q?2ZvAS6y4T13FgZlE4FTzSV4989jLEbncezCcjeI3WH/R7JUV1zaThCYuB495?=
 =?us-ascii?Q?1akhP5F/Y2QGdffVyBKWRhjRdVd5sAWsDpZQ1/NhirOdWTfDm3WtnHcGBcEJ?=
 =?us-ascii?Q?1Y8SmodtFdRePMlZRxGNsaGFW+V/Yj/fzR4UcjQiKTMpSouC9cNCWKf1uP6F?=
 =?us-ascii?Q?KhCmfEc2zXtJD1ZqmdjbwFb9wZPoAXImPZuVW1i7Ug8ySKfPWDa7FAyMzJky?=
 =?us-ascii?Q?cxA209nJ3kAdlj4k5LS2JFEknZxgEcxbVREAFMADTBmyBwEUO7mMUhDlOv5V?=
 =?us-ascii?Q?8qNvbMIW6BW+iLR8j13YBg8UzsaRucyeNiKoaauHiJoeeTgzUfQXp2q39uvy?=
 =?us-ascii?Q?WNm8TyUt4Lu4Ao0g9WyjZ53S5nz1hKpYzbFoSATDvgPiz/J5a7QsM+l9hYFv?=
 =?us-ascii?Q?lYb1K3eDNHzqE4loTn0zoqnbFIq7Si/iwDxVCW/O3WRUYFgYr75m7ORyN+rz?=
 =?us-ascii?Q?QOkNZ7vyUwCKWM9qYKVXv71s2Cxk7aiUgDIZzA1i2vug+YiRIoxz/NXAssUc?=
 =?us-ascii?Q?bsOr6droNFGFk6diVa6CJunBAEzIG0gl6zqVfVtuPxuJn682RPcs0rzK+KpG?=
 =?us-ascii?Q?iwdH1wo1zpQUmNcIdXbS2zdsIkreUcegK3cO3SozimCrgmuCFU2jACCMteVB?=
 =?us-ascii?Q?bMgs3DaQBZWBf1UpBdJnYNP8HzX7/BFk4uuRT7LyDuKnOG8kDHtWislDfa6P?=
 =?us-ascii?Q?FzJGPDljhvbNo5sBTIquijJc0Y+ujgq68PYlYAQCG9tXQf5GOkrRDVq3DLqv?=
 =?us-ascii?Q?BkeSPjeyOLTJFMvRhYKDtHT4W0ezHOi2yY0Jg97v8h/pZUVOm+ezUd3dyGRt?=
 =?us-ascii?Q?MTtYZJOlFoGJem1mzJkXkc1DL8XmLz8dFtb8Q1Q2O54V6RE3/koSPUb9ymOX?=
 =?us-ascii?Q?HuFNRg0pk2PrVe+ZWFPla79c/76YX4AL1XgAmCPzDBurH2H3/JZUUgX4u2my?=
 =?us-ascii?Q?SZDygjFverIjrscWjkVZ+M+GOwssUBElAlkvC8hbJk/3I2oy0FoY3Ju+osiq?=
 =?us-ascii?Q?dvWqbp/Wn/FR37Aa5mW3H3doP7CLAaqiP7wMynX4cu9zbwWAEW8IVxoy5zmS?=
 =?us-ascii?Q?uq3DEm5J4u7+aNk6KPRt/tzEd+Noc3VWKOplZb6YU+/h+FJDgV+xMSnyVkJe?=
 =?us-ascii?Q?3dce4xj7Qkq7IsXyOjE3Uxv8Qjp3DAk19jkWGgKSs+z394OaXVRmB7pIcQ/T?=
 =?us-ascii?Q?I0YtQo/eLsyTRSno/SvhjzfE9s19JOxTWL2ND6/wjbB6vzhdlHE2HRBM8zsq?=
 =?us-ascii?Q?tX1G0M5Ng4Pq1BznTvCO592N5aawL9lIvo/kvinPKpW91FW7SqRVO0ufBkFS?=
 =?us-ascii?Q?E6BiyaO7FjBwqfjbzj3hNE8ZgPlpsxF9/u0OmrZ/SI/efaUvG5NJtKnrpnph?=
 =?us-ascii?Q?U8tpogcjv1f6m4ucMfyCwO8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0DFC2CBE7B5B0C488F07E6DA13215AD6@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +1hS5JqBjDoRBumkC0uxxAkvgkySxHxc2ujFOYaSUUJRP7JC+XuP55L0rtvreOnwHpLltEjdrHc74X2H4nQ2yTPm2gZy40Q/efeYP0+rKn4AenibHuaNmNXTMH429SQbqyqwIHmmwGwVRXMJwIVn+oS/H8Klx9O/x2xiyE2/LuwGkZQk88LqLyOH9MKIAUq7GEfPfOfs3fmWT5oqCXADbvOZolged0X6LXddnzEvkHqt9sRJ0cMECnWN4uJ9XbCUlS7irIzZ+E2wmzbbj95y3YnPdMWkk/wtmYRJLf9lgJnmH9HZOZtsvaMIGBjXCk/WAG4Fzcz0gXQUtkR4BIiEOd+CQ9mBz13I1FijVyyCGa6Gn4V/z4OBIVnPmUOpKgXd1/Q1lo25XteMfI9/FK/SZVmHvpZi+XaR5HeehCJivGgQ/zFKM6Fdmjg4mejkpTYfcTso1OW6W0oRViDCQY7pTnmpCIJjlwCFDAEdL7etDvj9au9vqR6+zlSzu+74T+G6cdDM17ka0BKG+s0NJgGuPWS8OtZ5d5Hs6l/at8IGuHxBdjFpi2VCync88c9eSEChb+pU8fuUJ17u3VVUYD9Nfj70VSjMD+d49ruAc6R8cPVFIbM7VmKOSoyms/FzkNdkfa8Slywy2JfroC9Bya2iklBJNbC5TiaG4XzNaivEYxJGMob/fkwLKc+8/bQzuRoTVcsZ9p6YZuqwRmR+Wg+E3/rfydGnEgZU1Q3PpJJc3WLkQKmJhUJdN4H3uEJCZ20/3U0iss+muE7nhwzpVmX+T2g/BAoCka/ALKsV26G4CiBTZcHN9O4yMZWmDsEgh+xV+38MYcmEsh+SMwXpwNYOWMUv7kDXNvBB5zAoeueNRHA=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59325b71-60ed-42d3-e977-08db6896fd78
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2023 03:09:50.9462
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bYip6NedFhUNuSKyV8TDE0CV8z0rbR0KnLlEDe94qqNwi2CLQ3ClFAvOWQosEZJaqbpynqMi8Ef4m6t4kI6q3hTn41A1fTIv7WCsh4R4wP0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8377
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

[...]
>=20
> Vincent gets these too, but pasting it here for Shin'ichiro:
>=20
> Please find the latest report on new defect(s) introduced to axboe/fio fo=
und with Coverity Scan.
>=20
> 1 new defect(s) introduced to axboe/fio found with Coverity Scan.
> 1 defect(s), reported by Coverity Scan earlier, were marked fixed in the =
recent build analyzed by Coverity Scan.
>=20
> New defect(s) Reported-by: Coverity Scan
> Showing 1 of 1 defect(s)
>=20
>=20
> ** CID 462265:    (ATOMICITY)
> /zbd.c: 1554 in zbd_convert_to_write_zone()
> /zbd.c: 1554 in zbd_convert_to_write_zone()
>=20
>=20
> _________________________________________________________________________=
_______________________________
> *** CID 462265:    (ATOMICITY)
> /zbd.c: 1554 in zbd_convert_to_write_zone()
> 1548     		       "%s(%s): wait zone write and retry write target zone se=
lection\n",
> 1549     		       __func__, f->file_name);
> 1550     		pthread_mutex_unlock(&zbdi->mutex);
> 1551     		zone_unlock(z);
> 1552     		io_u_quiesce(td);
> 1553     		zone_lock(td, f, z);
> >>>     CID 462265:    (ATOMICITY)
> >>>     Using an unreliable value of "in_flight" inside the second locked=
 section. If the data that "in_flight" depends on was changed by another th=
read, this use might be incorrect.
> 1554     		should_retry =3D in_flight;
> 1555     		goto retry;
> 1556     	}
> 1557    =20
> 1558     	pthread_mutex_unlock(&zbdi->mutex);
> 1559    =20
> /zbd.c: 1554 in zbd_convert_to_write_zone()
> 1548     		       "%s(%s): wait zone write and retry write target zone se=
lection\n",
> 1549     		       __func__, f->file_name);
> 1550     		pthread_mutex_unlock(&zbdi->mutex);
> 1551     		zone_unlock(z);
> 1552     		io_u_quiesce(td);
> 1553     		zone_lock(td, f, z);
> >>>     CID 462265:    (ATOMICITY)
> >>>     Using an unreliable value of "in_flight" inside the second locked=
 section. If the data that "in_flight" depends on was changed by another th=
read, this use might be incorrect.
> 1554     		should_retry =3D in_flight;
> 1555     		goto retry;
> 1556     	}
> 1557    =20
> 1558     	pthread_mutex_unlock(&zbdi->mutex);
> 1559    =20

Thanks for the notice. I think the defect report is false-positive. The
variable in_flight is on the stack and thread local, so no other thread
can change it across the zone_unlock() and zone_lock().

I guess and hope the following patch will suppress the report. May I ask Vi=
ncent
or Jens to confirm it? If its formal patch helps, please let me know.

diff --git a/zbd.c b/zbd.c
index 9455140a..7fcf1ec4 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1547,11 +1547,11 @@ retry:
 		dprint(FD_ZBD,
 		       "%s(%s): wait zone write and retry write target zone selection\n"=
,
 		       __func__, f->file_name);
+		should_retry =3D in_flight;
 		pthread_mutex_unlock(&zbdi->mutex);
 		zone_unlock(z);
 		io_u_quiesce(td);
 		zone_lock(td, f, z);
-		should_retry =3D in_flight;
 		goto retry;
 	}
=20
