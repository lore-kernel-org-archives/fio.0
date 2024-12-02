Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C0133080
	for <fio@vger.kernel.org>; Mon,  2 Dec 2024 18:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733164664; cv=none; b=delghU7u9j2Ur8/prPUFGapOc9eivdR9Cki0cmT0bNmhg0oPN4kI+Ep4bQ/1o9J8pQ5gDleebai1/b8Jrm4KGCJeAGo2v7nP68e/enLkLkOY8ZVRJq/JqIOs53uYkcIi7eAviySPvDAhJAYnn/n9/xkCP5zHXEn4GPF9keaEuG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733164664; c=relaxed/simple;
	bh=PqO0v/n48oc15udiCtC5taabmBrAn/q39BZh8hZFQUQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=l4u8mQIVA0KtJc2MLm9xKMjRFk/4ax3Cqxcb1Uq46bHQplNPStGOhIw/VdVezu+rvotmgmraxYUlosuQFfLxG6qpaiLfgOEaxlKVVPGWvjIjncYQ3MKRxjpZOTZEPnFhEBgccTcbihLoC1IzEUvVtcACgB1nTTVEDiztX2uR0pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=em5r71c7; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="em5r71c7"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-46679337c24so38764951cf.3
        for <fio@vger.kernel.org>; Mon, 02 Dec 2024 10:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733164662; x=1733769462; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TQe6eVBtLm32Xungwrj2AIIE9vImN21PR41UoDT4bOw=;
        b=em5r71c7BB1cRBXqNmiBwibbqfW5klYaTH4VxDUXiiX3IvgjKJYgvsXz/46WzxMpJg
         WVXmceefw4c0n6xY92UHB7wFTnkmReErkW0iG+NRVIUi16mMXCHd7/2IuW0d3NGrJ6L0
         dHheE6b1zfeGAmY6UEMwrQtDg/+BYFKIY6FO70OW5nVxFxqi5gWgLE+MxM/6bD4RJ42A
         h0ebSW9eGqhRSv24hbiRJjHNCDXvZ/QPH7rFbxWVvVbGT/NdaEl/AATgi9BvY6ZxwsGp
         YTbnHXg8pJALQvF4OLBQbWQoHPTkUDeTbePNS116/gfczRUDFGn0DPgYCZbiYKf5F1rR
         pfOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733164662; x=1733769462;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TQe6eVBtLm32Xungwrj2AIIE9vImN21PR41UoDT4bOw=;
        b=PJK6pNfhtV+XHbCHJRGutXGgOwk56ndV0M9w/H1UKqYV7bvmhtwAt0ztTZyjqdlnHM
         zUj9fT1pwg+BB9Gxv4PD3ntZDVdjLL70bZtKcHRjDQKj1xF8hua/R7OHrmaV3k58o+Rv
         BNFOo+AGKtjn+QOMBRlWjncucYtP+43RTYt8TkMTUPfSpbRchrLZBPrrWZA7UeIMxWmT
         sG4WalaBT8ixS0snw9tFQepubBB7l0DXv9BqjE8yg8FuixnDmkDYXLVuvGo+qOKgKzhE
         2hy8JLaIB86nh3WAojTIPG6I2aT4XolQ7AcfE94c2asO4omKB/xHIz/mR8Ic2pcu5AkD
         uADQ==
X-Forwarded-Encrypted: i=1; AJvYcCWbjmx1f5HZEhZuxUDE2OfFNQRmV5F/Lc8TT1+pl552IkxiXn+/606VkMeVh6TwFGCAVjY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCOagwKUekIbf6IVzuyQGmwQC+bAFXBzDdCf7RDjfBZ7Hp4yHO
	47ts3Qs8rPFsvpbyybHqwmM1KzkKablfsCGL1rFQmz4gKBDzUeie
X-Gm-Gg: ASbGnctfucLl7DN20+TlKxwLiqE8+4j+z9PrM35KEAeFtdYUsnLvBCUM9XRSA6h3G3v
	MxnkJnPfKjldC4B4mFia3zhibHnOtDNr5zux4AZq/mMp4avnf9cS/2a7BieDjHtiTvoSnkmfPEP
	x7amZdyavjMFMfY8kX/Y3xdQI+zBXV0JO92ELG1qS6f+puCGh6vHwjYbjRp2mUdHknM6mn3Mxv7
	/G/nTpUQxM5ZvwGI8r8TUF1No6ARv2Uygel6D8hicEqbQM9BwlqSip1lmUYsVsM8DC0oglAKby4
	5hM9oawWHBf5J1NYT67y8wNIUA==
X-Google-Smtp-Source: AGHT+IGmkg7kby6XdFCccHSNIXaOum2auyCF662c1yGsxNbDf8eONwGNFqTxxEF1gflA+q/VKgeG5w==
X-Received: by 2002:a05:622a:180e:b0:463:4bb6:bfe2 with SMTP id d75a77b69052e-466b366f08emr446399001cf.50.1733164662014;
        Mon, 02 Dec 2024 10:37:42 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-466c407dab3sm51535871cf.49.2024.12.02.10.37.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Dec 2024 10:37:41 -0800 (PST)
Message-ID: <b39df833-2208-4d04-9e81-9bfdc37c8afc@gmail.com>
Date: Mon, 2 Dec 2024 13:37:40 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Could I use fio to send write zeroes command (NVM Command Set) to
 a block device (/dev/nvme0n1)? Not a character device (/dev/ng0n1).
To: =?UTF-8?B?6IqI5Zu95pS/?= <guozhengmi@gmail.com>,
 "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <DM5PR03MB31469D90F8C20E2B9844E808AF292@DM5PR03MB3146.namprd03.prod.outlook.com>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <DM5PR03MB31469D90F8C20E2B9844E808AF292@DM5PR03MB3146.namprd03.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/27/24 21:43, 芈国政 wrote:
> Hi all
> Could I use fio to send write zeroes command (NVM Command Set) to a block device (/dev/nvme0n1)? Not a character device (/dev/ng0n1).
> I studied the fio code and did some tests on nvme ssd, but found that it doesn't work. I wonder if there is something wrong with my understanding?
> 
> Thanks for the feedback!
> Tim

Fio does not support sending write zeroes commands to block devices.

Vincent
