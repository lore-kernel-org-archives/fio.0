Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BC92AE68
	for <fio@vger.kernel.org>; Fri, 13 Feb 2026 03:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770952658; cv=none; b=Ozo6w5NWnCHl9wQeDkF+FUdWdVZy8HlaveEClman+OqJYz655B+XSB7bWazXqrLTCM6NLucHbNlfSpMNgvN7wg2XevFLL/yzt8iSksMnLM0TSmHJd5mh56XprKXu+a2RYSLYF5T4buuq3QsItZBsQxy2eqgXLZ7p1vo676yTVAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770952658; c=relaxed/simple;
	bh=zBp9xCAvZKMeFVBZzQPRM9ko1a+rBmaxNUVd04J19dQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CbIEecmxnDTXkRrBJspHuCNw/yKHtqm+9tFYMS+AEOOWKksNZl+2lHh8Rri8l7uzJ9mNBwsrglCjx996A9E7JTxzViENA/g3ABYkmOo3Ay1r5/LKAZo5APOxfTOSiDyLwK4RC30DEx0+1kDkklqM5JDCy03dOl3PuBuDXSeZOWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MyGPt3sc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MyGPt3sc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7682BC4CEF7;
	Fri, 13 Feb 2026 03:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770952658;
	bh=zBp9xCAvZKMeFVBZzQPRM9ko1a+rBmaxNUVd04J19dQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MyGPt3scQRHahXL43HcDSLbaEPXJgMIXhgR9ppOtgGgmyQBlNdeTn9vwJP3TqzynQ
	 o+sUwDO3m5U8giNc5Hn0XO4K4wTXgsfA81kvh37Du6H10AsaZI/xggu/bmDDj1Cn2k
	 /T5rcYAboiHgJl1buX5otMhJrUPFyER10sbZJP6Vsswl1NMP1GIbCX52PID9jQNsav
	 1XRJ+17J7Wm4nQmaUtx7QH1rDiqaPK642lYz76Bmz7J07mb7YUauLeWGd8YpwzHxHh
	 wN3npQG+mqhu9qib0wJ8elsNeorGyPrY+laGMgezaHuaIDHrbRTxXwoHhsApy8Avd1
	 4Fl8VsvRsy24A==
Message-ID: <9992a9c6-e55f-4410-8107-d568381f403d@kernel.org>
Date: Fri, 13 Feb 2026 12:17:36 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] stat: Remove duplicate space in __show_run_stats()
To: Niklas Cassel <cassel@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org, Jorgen S Hansen <jorgen.hansen@wdc.com>
References: <20260206164058.3105327-1-cassel@kernel.org>
 <20260206164058.3105327-4-cassel@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260206164058.3105327-4-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/7/26 01:40, Niklas Cassel wrote:
> Remove duplicate space in __show_run_stats().
> 
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
