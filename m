Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238463043CD
	for <fio@vger.kernel.org>; Fri, 30 Jan 2026 21:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769806828; cv=none; b=QGhTA867BtQYLt4+opO9vK1Odx0JhaBbhJJhFOxWKAz3zyslkvy8Oh7Bw9HlwYtF0OMbyV1+1Ll+cnUC6Dp668leEu0KmYIqgaoUiIs4NR0eRnmr7uoqa8o9/XhIbRyQf1gD6cc6dsV90tIoMQlSWl6jD7BvjuwkLcJKGhZzxHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769806828; c=relaxed/simple;
	bh=TqjB/q3K4zwP1kPqYuBRJDri7+SLxZ5xH7fbuhi+5uA=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=JJAN/bkBWPUBNbuTVS2ncLIxr5nVU46h9+lj8jLDFTWPaNhPduhTd8E2qQPaChyoB+5eVswmXzv3veenm2PvJ11id1KdRkBgfbp2cUctLLYrhyoO1BoLtQ5KsyLOIJa3JRq/AKVfbpKzsB6p+XC4Hlfg+EzA4L2y9vt3UWuPkzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aDBJGyFp; arc=none smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aDBJGyFp"
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-2ae2eb49b4bso4421230eec.0
        for <fio@vger.kernel.org>; Fri, 30 Jan 2026 13:00:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769806826; x=1770411626; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TqjB/q3K4zwP1kPqYuBRJDri7+SLxZ5xH7fbuhi+5uA=;
        b=aDBJGyFpaQE5wKXMN1fUtx2xj9NIWIeAT0IB3TDRGAQ7z2COUlCxOr/IpNe4nYBKIS
         Nf7dugvBRNHF1iTGFejYQB47gq0NOM8WyRp5bjQzfvlQNGX3v3y65U8pDTgp6X5DUDIF
         eXMrdyX1CVUAVFgfEjPUgKXdpySyQv4G+UXZ/P52FzrgAH8lTVqRFlVBgFEI7FggLrp9
         M7IuYp3rTZoGTsWG6PUva4VCZ1uA+1Z+QoCH736EnGAzSpm49we1Jo7KeBRA+DuGYk8Q
         FiD+m1HPhmB5xDcaRt+JzoEVsYrgTj/BuCxLpsSDb6/nuIeDIOfhZqEHfEyNLFsAIyNR
         W1yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769806826; x=1770411626;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TqjB/q3K4zwP1kPqYuBRJDri7+SLxZ5xH7fbuhi+5uA=;
        b=vIAdl5ygI2KNajPM7vYaOj4p8HjvKsRZSHtmwvnrkM4u9O4Ux0cnQMtdlQ2cRjjxzi
         EV8zbuh5nXBAI9rpJanZlc8vvWsMRIv+io6w+p/+HanTjTMfoCO/a+Dr5rIyOmZCQ7+d
         zOPEX3RojC1yNRnwpCeajiJS0Y57bAkaxLUWHYkAR1bbR1L3tN1I1sihe9erLeLSlmEH
         nC/J9ESDutD/osU/59F4P2dAY8pYDO9agdjXElBVgdW267zJ/ko/s4EYXhqxkGrnlKCy
         ViecDlHaLBu01boKKjHmOk2gDcQs4vBrB6atbkucDuifEAKMs7g5m6uzCVlmdVinH+TR
         ux9g==
X-Gm-Message-State: AOJu0Ywg68muFOJf/I0nTcnhCauY/K9iy0F/retQB59gNrOuQSZSeqtk
	MIZWK3XKB/CcDHDL/LNGQ/onAOHMoTISCiasPvBLK+KZpgQFXlzxD4cl8EmZ
X-Gm-Gg: AZuq6aLXp6+En2WU83vUWY9Wq3ZpmOyLf2nc3tEyDVd5ziwP1yP6jEU0I/KUMyCrswY
	u4tXEScBLMMXHG/09UHsliwwF2GkdfUdgzpcjghJkjzKkJRszDxbY27wXZAVkmidy/1OLJQ1Iax
	fqqEdeanTeEE0dD3xl4+yYapwMJuCZy1p7MT9prL9WVAqUnpOIatCU+7rRahnIVkXsNxH26EMPh
	rxni4fXWgqKzbml5grrhUCOGFqbtsw3+eeuWZvc7k6hC6e5qfrQQscfTvpdzj3m1IbhDZdFwujy
	SbNLDFGK49HKGq7eOzXLW4MZ+peKScWnhNFMcWtUGsIwpSCHQphbVu9PtTpZPKsN94++ThTpAzK
	yanzCLkpynfOTGhGQKmutqsF1OirbIxxBWctVLXzvi1pxqMTeuWKtQHNkCQVUNiGMx1IfzlrOuP
	ccPFRG7YpL58/CQe4Fa92rlDT6j0iaexRYIAf1vM/WyFEaRZVeu9tqeB0L4GKOin4D+yokY0Usc
	z1emP2X
X-Received: by 2002:a05:7300:8608:b0:2b4:5153:42c4 with SMTP id 5a478bee46e88-2b7c86dab98mr2451983eec.27.1769806825738;
        Fri, 30 Jan 2026 13:00:25 -0800 (PST)
Received: from runnervmkj6or.arl50whhzdvufbrwthcsjsqx2d.dx.internal.cloudapp.net ([52.159.229.49])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b7a1add4c2sm12596426eec.27.2026.01.30.13.00.25
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jan 2026 13:00:25 -0800 (PST)
Date: Fri, 30 Jan 2026 13:00:25 -0800 (PST)
Content-Type: multipart/mixed; boundary="===============8479869387627026198=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BRFC_0/2=5D_Introduce_a_page=5Ffault_ioengine_for_MM_workflows?=
In-Reply-To: <20260129184302.34887-1-npache@redhat.com>
References: <20260129184302.34887-1-npache@redhat.com>
Message-ID: <176980682474.2827.10712070483539481785@runnervmkj6or.arl50whhzdvufbrwthcsjsqx2d.dx.internal.cloudapp.net>

--===============8479869387627026198==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: success

For more details see https://github.com/fiotestbot/fio/actions/runs/21529724218

--===============8479869387627026198==--
