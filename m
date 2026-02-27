Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C914D3EF0A7
	for <fio@vger.kernel.org>; Fri, 27 Feb 2026 12:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772194145; cv=fail; b=R06ir0mm282XSodCapjXhI/19/5YBN4kZZQKO92//KJsWuNk6J+Xpxk3lOnBPNs1x8wUNBoyNGVVSNN4NUZ09ROyBFgQV6ztou7WxK6lj7IT6ssfKELoGIo2GE7WwHL+082t4Lz6X4tBg9zYans6d+n2RUUk4pUSmhdLjhFR6/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772194145; c=relaxed/simple;
	bh=cHIu0AU5hihDLhC7UO/av3+e8NThYEVs2VFpX9ly5/s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uSCI53sZ87ROSxDPnUGVAEq6l5/TTub9NIXakCyyH3HM8Qzsu1ZZjrg9ew9PDB0IAV3SMcs8qP3HJqQE1qDBtFsngY8m+bdQTAHqpIPRT7HZVoip1pLy3yY15LugEqbFCJzj25EggVrUDdvQqRbF9OUpciNSmch6LOyJYkTRo7w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=SvV+Kr2+; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=U8TOeeJk; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="SvV+Kr2+";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="U8TOeeJk"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1772194142; x=1803730142;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=cHIu0AU5hihDLhC7UO/av3+e8NThYEVs2VFpX9ly5/s=;
  b=SvV+Kr2+UgV3qYsEAnAtnUs6XZx4NdwE94RcnVCMGf7bZThlyuYZr9I/
   CnsmOanaAqE40D8wylCQgOCRTiGtvhHha95P6r/PopO66SKtv2ZlMdGBT
   IC3ixJ5Fb3iBpRYMammvTiWNbEeKgBC+RQvsrFyTYzfMwQ38CWDpWPavX
   vzUwH4bNlBaPwClEFK8Mco7fdPHTNZJIhOnD2rWZVnvhTVzUzlXZPQ+ZN
   iI8mRNa0HoxPY6aBciz04MCY9VsMD936hOuB+QYrD+3PzLH0CeeQ0V+5H
   01ixb7RR0PwCFw7FdlVozf/T70L6XrNA4zFP5Fn9HPzfCFV0bBrVzy+hd
   A==;
X-CSE-ConnectionGUID: QKBehEHLS4GHYKVpN0uw8g==
X-CSE-MsgGUID: BVj91TK4SK+XMcX7ubOVTA==
X-IronPort-AV: E=Sophos;i="6.21,314,1763395200"; 
   d="scan'208";a="137990233"
Received: from mail-northcentralusazon11012020.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.20])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Feb 2026 20:09:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GgEp5rjxCzvvX9Wixo98oRpnRjdEd4B8jBt32IPwzMmFvd0fz9E274/e6xzMsT7Jw7uUQejTKWY7cGXND2V/T9MyGtEy+Y8dK54urpLtJJr2yOY7kTi9H4VOnZtJ///MsUgSSq1K4KkNWwkFueUGfhx5nu8upD8oKXKamXjkiv8UCgDD5+wBVx+5ty89KFLH405zDUm0/FN0hhCkBxk/Zw4CvUeZ6BTy0nNe+ZxI3xa6endxcW0pW2P2iOjkkwGsxkK2j/DWlU01koxyFaI58HfK4HJUfpxcislKqW6zze5fnN9rXAA4IkXbFeh6ZkylNAX7Bz0u1DFEQQ0Rv2IIFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5i3zs57y6N2Zzb/M9hisNSFuDmDBMMoyoE6r4557ggo=;
 b=eESVq1xVQWYWD7zSOVNEzxxrkIXnWtL5kTLWPfQG9aPNvJywtX3XuB2O5EiT1XPcqUEgZ/OPGxLhXNeZivi/cYeAGxh9DIjxoHCruw9nyXdMd/RkRAo7Xm+t7lpMfk/gDZAqm2BWa8+tFFbJIardF39S7VufZmAdGlA32LAessal2IjRsSpnHcKEdx8MfO3gy2djDnCwQRB9QSc/33zuJd1EMkQPTGxxpw0nFiCmiuGzErnaLGOYno8XG2Tw0ms2j+TcVNkogsN/FVSr7CMmJ09RcBixczM+mu2bTuiR8iJyPlEHXL/tPjAqZemZjh1Z+/DXqpRuOAcb+oQPRZyc0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5i3zs57y6N2Zzb/M9hisNSFuDmDBMMoyoE6r4557ggo=;
 b=U8TOeeJk4i0P30a2sEjHra3dslk7WTuKduBPxlaaVc99l6gpzFuUbvZ10Ue+j1UGktAtUQ7WccJ5furZLQcC/VKQpqkW7tVST1TOzPvM4QLNu75tcwC1xbLPM1u6o1nmqNnU/tZseYFXrOjI4ZOOwVJP5fUrQIRkz0lRocaEqWk=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by CO1PR04MB8250.namprd04.prod.outlook.com (2603:10b6:303:161::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Fri, 27 Feb
 2026 12:09:00 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%5]) with mapi id 15.20.9632.015; Fri, 27 Feb 2026
 12:09:00 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>
CC: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Subject: Re: [PATCH v2 2/8] zbd: fix write zone accounting
Thread-Topic: [PATCH v2 2/8] zbd: fix write zone accounting
Thread-Index: AQHcnxo27DsWH8+Q/k6ODdpoZKhBLrWWC/SAgAB5iwA=
Date: Fri, 27 Feb 2026 12:08:59 +0000
Message-ID: <aaGENdb45uNtc6C3@shinmob>
References: <20260216075936.3318729-1-shinichiro.kawasaki@wdc.com>
 <20260216075936.3318729-3-shinichiro.kawasaki@wdc.com>
 <e1c6465e-8eb5-4a4e-b323-c31bccdedad2@kernel.org>
In-Reply-To: <e1c6465e-8eb5-4a4e-b323-c31bccdedad2@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|CO1PR04MB8250:EE_
x-ms-office365-filtering-correlation-id: 64e22707-427b-4e7c-707f-08de75f8fdcc
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 9hBNzqnrOeLv6TmhBpFgcjQGboGoZmAf/UVODyDWLYiwG0tfNl8TeAf7FCJeAaWvOzG1T6ZlCS0o5nU42sIld892VhVeH0Gb8QtdaSJjcpycLwdS6Yxwj3t6C0Wu5gBYe3sExC53o9mIEa5LGbTUu7G+myDR0+W3Sv2cAZU5bO8mBmFnqF16TH2Xorade5kRjZ1HZE5IFvcWl/MEyc6QKedkGZjAJ3Z7UKrkI5JQV232tHcZJBMmjkWl5jqTbbsD+mY6iTSX4rtr1fyaeMIkI6RszcMEpO4l/ruwM79Zw33HDwXSCQ8wgtYTkWTscAmNar/iEb2rRnuRYwOYxxcbIKomH4mURP9UeofEr5j7BnsLuCgleIuKO7KQcz61ZhQ6RbBuqQYlb3Y4NkDruz2hCcYVmhgyychfabJrmLwsVbVEU9F51nKoqE8deW++eYecJz6CFO0ZZ9AazNqn4wR1U1uA8eHpi9xfgLiQbukIo7JXFdDs1RVjTCLTzg3x5OUFj9Ix1y8rxIo3++PyiUQgqYpsQvamfVB0e5xTe6mjyu4NE3JsNPOZzOJdBuPOGjUnbb/bSKdQpaWt14mNX0fXvtiOehMGc+YDwduWIi7MqP2Lze4btpF/Jnv0d5198BGsaM17KR5SVWFk5fLca+iQhkLdgEDXT/c8Uj5NqEGNbLrWjzJwHPSwRudROpCtjWQdVOnB4UmVcO4vo/ecOJT8RRVN2ymKV6XZv3mf8cBLR3d6fE3l7y7/lix0iR7r+unEp0Rn0k0yQvt2Z5xwUZ0joWTgBwDL0bTtKkQhwipr7LE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?tSWMkDYn+xJDN6sfjHtWCbDwLX98O/AlWUlAtl6Vloaf6YStTQIswUmUYWvZ?=
 =?us-ascii?Q?vAkc5a7QqNl88TscbHGqCbcQpa0aEtySiqjygYXiPpnhza5ex9ZXCuxkP8SS?=
 =?us-ascii?Q?+Xjp+OUA5Jwep4PQlTItpIKLQgVUjv2WenXmj9aYQosJfOuL3nPwKGP+jwrL?=
 =?us-ascii?Q?zIZo6895PC0jpqoGjWqENFJFEKRlnangssXF6EqO7C6pUB1QoQ6OvqXJlwT0?=
 =?us-ascii?Q?wWio8+8J1UEsAzzTn8q7O+UdmDD/yt2s3vANkNPR/42MO7OueSKl/45zjwGa?=
 =?us-ascii?Q?+3HMMN6Y9I8bdxWQfNm/1nDap0kXbxIsTuQvTpCH/vWzCPPyovYne3em6CNj?=
 =?us-ascii?Q?FV60YmTgL7jEbHNhpkq2ModyipgMoQ2chiB0TtFSFNsB0kO+wSh0Te5pVJsc?=
 =?us-ascii?Q?1KKRueBVS4jQoORwkgHtmc/i7aDMykLqmY6e2Ul4B4T/EP7b3D8pcpv2hjeP?=
 =?us-ascii?Q?xgmLt6oUnGHqCLcfDKRTz2JJu4az6OIIA5LpWQX9DVpUkLzA/tlEC0PIVjU/?=
 =?us-ascii?Q?FGqr6T+1gvMMMybrMC4EYNi68JWcIJIMJzj3Jiri2r9g+1GcRbL9ZGPqo2xp?=
 =?us-ascii?Q?QRQjBxrYErMch6NRHMwmUM9A+GJJFq0O/0AgVxFV2OrASBLbuYdoSo1tlC8z?=
 =?us-ascii?Q?byUTCpGni3gsDjXGiDfyKAY4aiK5c0BocG6Ode5BK/Ec1U252Rz2oij20Hrd?=
 =?us-ascii?Q?I+b9oNE9IXHSZn7qCFmvo3jEjKdd0R4JBDABwGR8SU87UdE2Z21alJAmV6hy?=
 =?us-ascii?Q?4nWd4sohRS7hHpZ3P2sgKqDlzXvxrLV7EllB1J6E174win29b55h4furz/En?=
 =?us-ascii?Q?NN/PmY6M7Qr9mjexD2s/DVB7J0/qA1xP40U+bBbHb1mjSZ/RtSH5xGTn74hz?=
 =?us-ascii?Q?xrNm5jeDMLRStqa5lZYbMWuYC/9sHz7HIBGkXN1PmN9rHfrnJr2iA6SR9M7u?=
 =?us-ascii?Q?Vc2z2kNAM9e9ypg9rqc4Bemhh9Qy8UfV4PChzQ9QN31kl3zG5KEW8dxtoyfZ?=
 =?us-ascii?Q?1XIxB3i1QFnryvRNpVaXUw8vZrtuSO29ElnC5vZFWHtGP+k+uozfmrv0shOj?=
 =?us-ascii?Q?eBZkhNQgma53ti87EyyiBi1MV9AMJiwFHdivuwemw4/5w2gL/9pWasiZEkzq?=
 =?us-ascii?Q?f97U+eWgY7QP8Zv0xBD8MA0YLBPaRPBefnfWHvZfIzjrwOQwce0FbuvrlPq0?=
 =?us-ascii?Q?fO82cHyhISDj/3y/q1t81IbzXMIya7YlxHxZMPty0E4KtiijM4tab7HQoj9e?=
 =?us-ascii?Q?qMHkg1SxGzvVFbylVNvhBg4PO7PONhMJmSNCGyHwSww4biZNX0JQzXGqIwBK?=
 =?us-ascii?Q?TO/DynmnKsj1DCe/8AGlJN8CRhRnf0+c8bR34Ez/dFFeg6vMkHbCutEtwHEv?=
 =?us-ascii?Q?cf8hHDMtvDhq70p/JnFfBx2DphW7nlukBKc8F5Ft7Cz2My2i0bXw3m+1XXnY?=
 =?us-ascii?Q?ez90mQReieKjIuHQko7JP15cEqt/9FLnQa3t6HXSyAyc56jAJSeatw5S+CRo?=
 =?us-ascii?Q?9zDhj1vesE0zbkDFHnv9ZaQlQ8ivxBLzfDcFBpcUaiCrVFmbarPNha8tRPoe?=
 =?us-ascii?Q?CdieIW4UNhP0ewRoBE89veG10+iz6IdTnQX+Msh8CYMdmCS6lDhtCGDXFrDK?=
 =?us-ascii?Q?QSVIPbbxtofNl69y1oDjtCC0SZeKYomtkM6Q7wyl0ZzirClHsLfxhWmFSAos?=
 =?us-ascii?Q?dUfH6xsncNMCQVr0FIMxxJaoz0TX2knKaIYMwKg7SwBsyvX712Fbt18hZRIi?=
 =?us-ascii?Q?TjepWC/ULglB955NLXzYD2f5y8V1uHU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D1B26ADBFC638749863857D135EAED68@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aLlrjF7sJ1/I03f+BWxfE8p0uUMSXSZk/JSJv2Myj0awnU9OoOgMpMqU47hFkrxhE/mnuTTtqaB4mjZ5+p4utC++Emxj5MxqFhbRhYEj6c7vjfWkJzyxynv1mhdSLVmg0UvwiHlBqTbWEXhb4fPeXOP3hg5GQOqXxoJgnWmHWAlF+3fAWOz8TziBqKlw93wY1n1SIqOIHQzSvXb6L8geAlZkKR/hejqcGwBICp6Nh1zd0chs+ClAtmNc0agLxD6acZ4nyqUiL9YKZEEy/WMV3UZx842MoD5YpLAo6k6tgSFL5/AINzWduGSlFXOqkvR7SsPCtCHjvqwtf2mQyTH3LisJ4O396J6BSVrQH/K0mPwPv6YFLOnTaElzPQ5dZuoP7S8DRhl4jPNk/YwzDjBc0bDvu9EAqwWrFqddTIts3U0JjOo5K/avYqLZMz+hlGv75kqIDeK+dOepfjUd9933K8sRGSxQvA6I049mz3+Ya0E3RcMyoTg3f3k9lvfiW1SSKhp+z1y3i2D5DTlC3sgL646bfVZypEGd4uGB1bWFFxLiD+3I10yHJ8vm8D/hsWRGTifsOgL8a8SIYiv2aEEdN6M4yOB9L6PnaDC1kzxFXmvPWOu090RO36RSXD8vSMJj
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64e22707-427b-4e7c-707f-08de75f8fdcc
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2026 12:09:00.2965
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ny9ZHf3M6qsPYcOP8t4wGCrYZpFPmRC2NjBeSjyGowjHIRHp+5sbSnv4wR5bhE0PhoelZyoYLMK3ZToy/irOjPVekPg/Z+UBLmXuyLiLaPU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR04MB8250

On Feb 27, 2026 / 13:53, Damien Le Moal wrote:
> On 2/16/26 16:59, Shin'ichiro Kawasaki wrote:
> > Currently, zbd_convert_to_write_zones() calls io_u_quiesce() when the
> > number of write target zones hits one of the limits of write zones. Thi=
s
> > wait by io_u_quiesce() significantly degrade the performance. While I
> > tried to remove the io_u_quiesce(), I observed that the test case 58 of
> > t/zbd/test-zbd-support failed with null_blk devices that have a
> > max_active_zones limit set.
> >=20
> > The failure cause is an incorrect write target zone accounting in
> > zbd_convert_to_write_zones(). This function checks the current write
> > target zones, and selects one of them as the next write target zone.
> > After the zone selection, it locks the zone. But when the zone is
> > locked, another job might have removed the zone from the write target
> > zones array. This caused an incorrect zone accounting and the test case
> > failure.
> >=20
> > To avoid the incorrect zone accounting, call zbd_write_zone_get() after
> > the selected zone gets locked. If the zone is removed from the write
> > target zones array, the function adds the zone back to the array.
> >=20
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> >  zbd.c | 13 +++++++++++--
> >  1 file changed, 11 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/zbd.c b/zbd.c
> > index b71f842c..c511b709 100644
> > --- a/zbd.c
> > +++ b/zbd.c
> > @@ -1693,8 +1693,17 @@ retry:
> > =20
> >  		zone_lock(td, f, z);
> >  		if (zbd_zone_remainder(z) >=3D min_bs) {
> > -			need_zone_finish =3D false;
> > -			goto out;
> > +			/*
> > +			 * The zone might be already removed from
> > +			 * zbdi->write_zones[] by other jobs at this moment.
> > +			 * Even if the zone has remainder, call
> > +			 * zbd_write_zone_get() to ensure that it is in the
> > +			 * array.
> > +			 */
> > +			if (zbd_write_zone_get(td, f, z)) {
> > +				need_zone_finish =3D false;
> > +				goto out;
> > +			}
>=20
> The way I understand this is: since we do have a remainder, the zone is n=
ot
> full, so zbd_write_zone_get() cannot return false. So this looks OK, but =
is also
> very confusing. What about removing the if and instead use an assert chec=
king
> that zbd_write_zone_get() returns true ?

As to the failure of the test case 58, which has one write job and one trim=
 job,
I think your idea will work. However, I still think there is a tiny possibi=
lity
that zbd_write_zone_get() returns false due to the max_open_zone limit and =
what
other jobs do. As I describe below, the zone can be removed from the write
target array by the trim job. And if another write job exists and if it ope=
n
another zone in parallel, zbd_write_zone_get() may hit max_open_zones limit=
 and
return false.

>=20
> Also, it is not clear what the conditions are for a zone that is still no=
t full
> to be removed from the array. Can you detail that ?

As to the test case 58, the condition is that there is a trim workload runn=
ing
in parallel to a write workload. The trim workload can choose the zone in t=
he
write target array, and reset the zone. After the reset, the trim worload
removes the zone from the array, then call zone_unlock(). The zone reset by=
 the
trim zone can happen just before the zone_lock() in the hunk above. I think
write workloads with the zone_reset_threshold option can cause the same fai=
lure.

>=20
> >  		}
> >  		pthread_mutex_lock(&zbdi->mutex);
> >  	}
>=20
>=20
> --=20
> Damien Le Moal
> Western Digital Research=
