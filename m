Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB28D23A9
	for <fio@vger.kernel.org>; Sat, 15 Feb 2025 09:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739610841; cv=none; b=qqDj8sZHBCLFWplwskCv8T5S+jguxuglos7Jlh3iLh9o6uSzdFsw6VgKMkzteORfLFTt/1caN23lexCDbCDpx4Snzt5nWO3x91DHUoGivez43aQtEQHBl3YZLPy3x51dv4PlErJAM6PSmlUj1Do9b+7/sX/V58fgQaZLugjdgso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739610841; c=relaxed/simple;
	bh=2gO4MwNcptjz7Ho8x34hb/F+p0FnKNPnOgfyjHW6p5U=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=ofS/dP4gz4VuSalqUCGzShLUJkGf/SCJVgxgg72uUhde+cKANEYBx+Vk33xLCqJl5gFE2VmDmRG5v2Qvx0RCvl4Y2fVRDql/GVNJLJL/WWgWexIOwcCsVSfCnE3/sWNJP8zRsXKCjXSeXHsx6iGbXGybO35TY/PbvA1Xgqe3I7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i83+P6ww; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i83+P6ww"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7c08621f6a2so120025085a.0
        for <fio@vger.kernel.org>; Sat, 15 Feb 2025 01:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739610838; x=1740215638; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2gO4MwNcptjz7Ho8x34hb/F+p0FnKNPnOgfyjHW6p5U=;
        b=i83+P6wwQzD4/PSUIafbO02tGFRpvyGy23p20a3bBk6IIQudytN4bx2ndhyg0RkmwD
         4qZHgg9V9G/HFuxj8uLTWraBx2Vi71kbHs1GpR9QzHGMJs52DTXQ3L/DbhdoMruYyIR/
         0JppIr+qPutII8zDCJJSuPydzpQxYQ8Fygzg64t2A+6P4mI5sElXBO0+iTQVfI9Q6oI/
         Pi5zPS6j9vdcidwnOZ1hLinFrV7Y72g/45nJoE2slHS7KPhkc79csTpaTxi8I+tn/y+e
         xfVfjTNvYmr1hG4Q/7FaGbe1eCNaeEk5YVY8PsvLbHvashBGObR7Unh9PQtCxArEmvGe
         1Wgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739610838; x=1740215638;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2gO4MwNcptjz7Ho8x34hb/F+p0FnKNPnOgfyjHW6p5U=;
        b=Dmko2X9N/dfalkJ31M84R2YoLZSVN4arlW628nmZolEWA0Ks/+EGd7Y+QUw3wO7KEg
         TcOalJEYcVZzR8zaSYqL0Oc1/wmETVZB13ixiOpGqYaORneh+cod4a4H367QJmG4ByMH
         Z8fqURuTcm0MrmmVxObrGKQsXHjV0p5538U0rTIg/x3dzsWNU1ml/plNIJpvC+RZzLaC
         A6toRrf5xtYvBSketPn3SZgONt9ocEa0BtEJIoCIA8C+pDxkjBIw4CrfAly5QPcLLXyb
         cLb6mgBbvhNM3DDorwGyrMTPCsPA0V82628oSVxskhRR5fbAvf5BF1jq+ut+exdYszeb
         Ze3g==
X-Gm-Message-State: AOJu0YxJ4v8xjhatrfcVdMUYoFui4+WPkBuGkS9j0aZOTgoKNcoblwZu
	HZ/EPkvrcDFKs/y7CWlsYGpgpTnj7R2NTSVNKYC1wD/jvOzoSILqnFZD
X-Gm-Gg: ASbGncuZGDLDiuXiloYGvd6b74X/Z7qtDzVwFw+OlS3VsX7/eZguoaoZZMSOJ4BGgwF
	+tMYpKg3rdf24nGbraDuhVz/UPF3I2MZA+KHdFn2vKuA1y+zbBPssT2XB+lIH9eIzyfa+9RV1j3
	zxTxRdRjkGdta59g+uWfOdSiY5ywZpPceX/qY21AUcn4grM4fBuDNl+JF1VE4DwkCi+zBLs4E6E
	JuidjrWpDG1DTHaXGCkGnRKL6QXcOc0oj2BD+liNS1MRCGN1s8xipbYhQhEWCBdtUQhTmFSmevS
	nLXRMOJdI33NqavBx7c1u/3c4ArLqJjEn/BXja0Q4ssYdvVm2FqqwMA0YM+njm5ek6/QrOGC1Dc
	yg7TdOKzvcQ==
X-Google-Smtp-Source: AGHT+IG92n4W8iVze5cqTUebsOmeYqWGxfSgvGJPxzryS55VZ6YNzlJadMlqQJCjFItRKEpwz41/+Q==
X-Received: by 2002:a05:620a:4441:b0:7c0:7f07:a635 with SMTP id af79cd13be357-7c08aac61c6mr370587085a.53.1739610838436;
        Sat, 15 Feb 2025 01:13:58 -0800 (PST)
Received: from fv-az1970-919.jylfb2lvhi2edjyxod04kr2g0d.cx.internal.cloudapp.net ([20.246.78.212])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c07c86e5cesm298071985a.93.2025.02.15.01.13.57
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Feb 2025 01:13:58 -0800 (PST)
Date: Sat, 15 Feb 2025 01:13:58 -0800 (PST)
Content-Type: multipart/mixed; boundary="===============6189706373974824806=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH=5D_libaio=3A_Add_vectored_io_support?=
In-Reply-To: <f0d66512e3df3d2142910e996c42389c21232d12.1739608655.git.ritesh.list@gmail.com>
References: <f0d66512e3df3d2142910e996c42389c21232d12.1739608655.git.ritesh.list@gmail.com>
Message-ID: <173961083756.2483.10072616510521829049@fv-az1970-919.jylfb2lvhi2edjyxod04kr2g0d.cx.internal.cloudapp.net>

--===============6189706373974824806==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: None

For more details see https://github.com/fiotestbot/fio/actions/runs/13343516855

--===============6189706373974824806==--
