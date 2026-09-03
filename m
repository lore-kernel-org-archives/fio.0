Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C15F50C2B4
	for <fio@vger.kernel.org>; Thu,  3 Sep 2026 20:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788465728; cv=none; b=uCoz+mgYxvw1BHKMhXRQAywe5FRzIH8K0osnusZdFAcc5t+5ymeHTAaIHMRdWXEM0p+MRRNspvH/ue3vMZUx6/AotABeJjio4kYkmCLCzOgQgaWsoCDQKZQ93zzqtM2OvEeWdLJ/Ge36i8R7mkteN4DoNvjxd2j5jQi5SEHTtAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788465728; c=relaxed/simple;
	bh=Ehzd4Ca2FUIpfw/3tbtRYOox+yZTus2LdSE2mDlyx7k=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=QPxA2BjjQaf6lNjNf4ZIN/kzm3glWgQa2BIH5yPmpz54z288mBMbW35TMn/0KDVmac/yrEuMv3UXGatHG9n3jf1Ue2aMIPeLv9oIlUD2SzMxBY23zJst9X8U0PH40Dr3ToxOFLm2UDKgelOYtyMGJmbFb4ZGQVfBuFiKt2YlkFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SHpov5uM; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SHpov5uM"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-48a0ca07c38so260199b6e.2
        for <fio@vger.kernel.org>; Thu, 03 Sep 2026 13:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788465711; x=1789070511; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version
         :content-type:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ehzd4Ca2FUIpfw/3tbtRYOox+yZTus2LdSE2mDlyx7k=;
        b=SHpov5uM1sjer8uwdka3erBzJyBeUuVbYwUMmqA3kji95oTrQ0smI640KJk6sS9b7i
         7ku1tziXhqxwSyo+PuouqYBz5Kcal8twJP0PrMGrFcJB0xgY/9J2ym3CxtACedDdmHnd
         0eKSFNZz8yfPjNAh2y4X06yCVPgRfJua8mul3SBIsXyRkg2WxxUsqfppEanJSAOm/yFb
         orbhXIrjSX77jhYlbt6vc53+8EY5I/ft5B84aHuSzQ1AS4XI9oBPk2N3opInnOKOcSKs
         B1Bwf41OdFkY3zESdtDBBx+roQb9JHxCdRxkjX4SpDl5xLj5ktouUuTHB2AiadWg3vWh
         chMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788465711; x=1789070511;
        h=message-id:references:in-reply-to:subject:to:from:mime-version
         :content-type:date:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ehzd4Ca2FUIpfw/3tbtRYOox+yZTus2LdSE2mDlyx7k=;
        b=tQCr1fhEiaVe/X7lT9PQpWcHMvXwwr3ev9JI4UBxbKaOUgpOg8IsrZaZTBj2dH91SH
         piOe+SX6JxuqJ3f2h5WiAmgRtng4XuD5PhmgdTUUaeS/9su8yaFHx0P5H3NQPbVghPio
         st0RRFFxY7fZpIIJHf0I3POYJl0Q1xfLzUxj+E2u92c400+aAHb1TiIFopEiY97IltkN
         H3JqXS1QlYEEhloXNoRqjm//VSDWJX2S7hMgiNniFU+Ro2Jo/W26NegzTri3kXz3H9oV
         UTI7kuw1HPpojC4DrflXjCuMsu4QjBNiHv5cgWhDWOfc5WsiRRAIVlFNeGv1ftvFxT7u
         vQAQ==
X-Gm-Message-State: AFuF++nbdQRc/osbNXO/Q17CHKQqy/tmzj4eF9jommYmcktgRF7fzoyD
	3dE88f6gvvE5izA4DRNJzKLOC+ggbhPFHn6XyesFaAUshzrfTdQTp5EF6Po9oc8=
X-Gm-Gg: AYBFou3z4sZOuOTM5LtdWCL9pEvcc3xjiJNwa14FINmKa1Oy7wFn2xVfZcKjEhnZssF
	Icv1bDfJwkcjAe6StZGw4gGhNH0EYX/xB7dXCd/EBGtTyFVxxV4uQz3MbzhAg5rXA9uotIccLRm
	vWBC17Gk6k7PfI9LjQTMe4+BrFSMmscHUgv39YisQonRGqH8Nz0Z55sGB1MyI/8FDVsGzNBpj5+
	qVrz0A/DXpZviTQYhv3xFgS0IurUOwz7pniX9Z2rW+zkL91my1acWVGQNcCK6hQxR5AzI12rBs2
	bzU9xpMG9kzBDzG+13rWqvrKtVEIdHzVESD1jtESy9jJYv7+6SIA2dggIZIF3AuxJ4stRKklrGW
	z7dfebD/QlAhBVFzfwQ3J1HAzSeaZa5idBEimR9C2YD9Ds15TbnRBIRpKpH0W58qlBmiH5P55Yu
	VBhqki1BGYr4o8g6xx22SbZFfR4CyDy1GqA/rLt/E/bYZDNTzX48xeWA8QKRMwuS94W/eTBD+4K
	HtP9G1nNfWi6RJusjLfVlmbgI/yvVLdofzR8i0ZSKbaU4Y/qKxG7KSQNql0xi1lz0/7SuE=
X-Received: by 2002:a05:6808:180e:b0:49b:c387:36b6 with SMTP id 5614622812f47-4b961b7dc1emr896166b6e.13.1788465711342;
        Thu, 03 Sep 2026 13:01:51 -0700 (PDT)
Received: from runnervmejwal.jgw4jbjfx3ludlxuygy41f2yrb.gx.internal.cloudapp.net ([52.165.101.53])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b971240f68sm235235b6e.8.2026.09.03.13.01.50
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 13:01:51 -0700 (PDT)
Date: Thu, 03 Sep 2026 13:01:51 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============7739685228051700891=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH_0/3=5D_fio=3A_fix_eta?=
In-Reply-To: <20260903172101.1886315-1-kbusch@meta.com>
References: <20260903172101.1886315-1-kbusch@meta.com>
Message-ID: <178846571041.2687.17888430772956481215@runnervmejwal.jgw4jbjfx3ludlxuygy41f2yrb.gx.internal.cloudapp.net>

--===============7739685228051700891==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: success

For more details see https://github.com/fiotestbot/fio/actions/runs/33784801874

--===============7739685228051700891==--
