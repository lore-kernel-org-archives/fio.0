Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CD43A1E67
	for <fio@vger.kernel.org>; Wed, 17 Dec 2025 22:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766011948; cv=none; b=XnZiD+Iz11LtY9Q3om5DV7+qI3eMoyCODi9r2SndxVr6aLDb1r4Sxr6eU71jLsr1aHDQC7p6Om4sXfLclyte0kSN1vpFV53Bb4BNO3TfaJSuGxTLYNKy9TKPWHQZayWBhz++QTUJWfWCpNZWbIukIUv+iz4utIFtI+pg+CGsPFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766011948; c=relaxed/simple;
	bh=TuQcswGcx1bz1xkMbeH85Cf0PdbooYlcXiDqPBVivxk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kNjSCQVKFP6MWssRwCOqRAQZT7u7PpESiEvziz/gbC4usCN/wajEgoLk451hQUStjI/rrNOdQ82OI4R5MdXVBUxEUlJghEPXv8GdsXGoj2xyiBQS1fdrcoUaW0Gm7NQRq/RH28V//EllY39ZBRHrlOCyZzGmn76kYgsb7OvfYC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jE/1Tlkt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jE/1Tlkt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7929C4CEF5;
	Wed, 17 Dec 2025 22:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766011948;
	bh=TuQcswGcx1bz1xkMbeH85Cf0PdbooYlcXiDqPBVivxk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jE/1TlktAp9RjQedEzgb0KJzwYAqsExGs/Ws68GObyXXF5pHFVd08jmZbmktGUvkI
	 gTLbgWZqpcWSV7JddTUKqQGijenr7no9+mucLtkqatPVpFeJLiFrKP7O7dmUex1jGk
	 YlRj03Tltete+BOLSXA5Khe/8OJfJpBescj6UOL+xiDNZQx4Ss0NCtzaONCMu0BRZM
	 kTRLgtifOb7zZjRqyrBqU7D2CQ0MPZcJL2NeL/5Ihku2v/SdxWt6vIRdrJEGkYE4pC
	 0MidSwZTzRnsmVh8jp3kMhnQ9nVaTb6WVv0IAFmenvkG8mizHxb7T5Cay77qOG6wbW
	 A0lgul2aj7Xtg==
Message-ID: <5b5d6b75-cc0f-4d7d-adb3-a7701b9289b9@kernel.org>
Date: Thu, 18 Dec 2025 07:52:26 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] time: rename in_ramp_time() and ramp_time_over()
To: Jan Kara <jack@suse.cz>, fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
References: <20251217160217.15533-1-jack@suse.cz>
 <20251217161722.6357-1-jack@suse.cz>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251217161722.6357-1-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/18/25 01:17, Jan Kara wrote:
> Rename in_ramp_time() and ramp_time_over() to in_ramp_period() and
> ramp_period_over() respectively. We will be adding other not time-based
> methods for determining whether the load is ramping up so the old names
> would be confusing.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
