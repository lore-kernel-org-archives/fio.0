Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB191537A2
	for <fio@vger.kernel.org>; Thu, 29 Aug 2024 01:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724893526; cv=none; b=pSL9N9bfFcYxTqs0X0KLTI9jeBDwv4ZC3vcrjRvOpw7AIBQqdN60dN56T9fIlgWkVEE82Wu07Wri2ZTaxtLOYkx7pMq1Ei4XmhIwhsrbjOPkAm/UK668a3PEs01WFX7eX+wXwrNRWxRBb5CGKPocaQ5+dBf9/hefYdI8u0dadEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724893526; c=relaxed/simple;
	bh=5fxki23Az5fBOHPL5/ijYsZmqF+C6bfqZ23ZRfPuTFc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jzR0y6Cor91k/NpBNurZeoVuhOg6qlHsDdtQJfkhsLWCXYKzRIl+JV7dX5+wWEKG1492Ekba9H1v9LVRJcL/W2CZROCSgasTotL5KWc0qf2GCLaPT97ZaY6mlMmBMnRviTS099Y569s68kZAWAmbVY9c++L7UxXtEKWXeN7/OZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HSWs7M+U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HSWs7M+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E031CC4CEC0;
	Thu, 29 Aug 2024 01:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724893526;
	bh=5fxki23Az5fBOHPL5/ijYsZmqF+C6bfqZ23ZRfPuTFc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HSWs7M+UNNNnDV+V0hSibnrwcj120MMar0vs8B3le/G/j7J2sFugAHGe2ZKtqRa6l
	 M8nklUfYNU0uFLfacayNgtwAehK2Zi7tXvEHkhl8E4MxAMR8KWuIfpfU7KzjRG5wKn
	 8AOQNPSFVqH96JsxFk7i0APyOmOwlE71QUjL2zD+lq+O7jmdkf7Fa/66t4zTkVlseZ
	 an0eBIirv98ScWlzi9dUHfOVAryo2IRP1CVbOjhVejp/mRNXagCjem4DtDAy4i4yfd
	 g0JMigofx0+NSq+Hy6w49+X+J71Z0RSVkSgqcsjqmSwShwvcEqYSCelDozSCSlDx+u
	 oTJAAOpHePq5g==
Message-ID: <51c896f9-7180-4465-8f32-434f237d157b@kernel.org>
Date: Thu, 29 Aug 2024 10:05:24 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/9] introduce the log_issue_time option
To: Nick Neumann <nick@pcpartpicker.com>,
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Vincent Fu <vincentfu@gmail.com>
References: <20240827070850.947037-1-shinichiro.kawasaki@wdc.com>
 <20240827070850.947037-6-shinichiro.kawasaki@wdc.com>
 <CADqNVTqZJ6oB6QsZcKgeP+dsCmFJug=pPQJbrhgbYSNo1+1Rcg@mail.gmail.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <CADqNVTqZJ6oB6QsZcKgeP+dsCmFJug=pPQJbrhgbYSNo1+1Rcg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/29/24 02:38, Nick Neumann wrote:
> Do you have any thoughts on eventually including the submit time or
> submit latency in the clat file as well? Then one would have a single
> file without any of the redundancies involved with multiple files.

The submit time is what Shin'ichiro patches are adding :)
issue time == submit time. Maybe we should change the name to log_submit_time ?

With the code refactoring/cleanup that Shin'ichiro did, the submit latency can
easily be added too. Though one could argue that the "clat" name for the log
then becomes a little inappropriate.

> I've also thought a bit about having a non-text but portable output
> file option, like protobuf. The files are large, and gzip compresses
> the per-I/O logs well, but I imagine protobuf would be a big win for
> both outputting and ingesting the log files, and would be way smaller
> than the non-compressed log files.

Adding an option to change the clat file format can be done on top of this series.

> 
> Thanks for the new feature and any input on my thoughts!
> - Nick

-- 
Damien Le Moal
Western Digital Research

