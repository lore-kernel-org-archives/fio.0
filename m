Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186921CFAD
	for <fio@vger.kernel.org>; Wed, 20 Dec 2023 01:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qcH30INy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C9AC433C8;
	Wed, 20 Dec 2023 01:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703035890;
	bh=sUyhdat236M1hv1T4EA4WYMnguk0wZwoNX/0O3O1GsA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qcH30INy+ghYhoQ8drDWZzg3sSrRUXIk4XH2OgKXb/QTe/+rHRHtdj/h/ttlhfwap
	 Xdv8BqFxGgvtl6BOaVL7hgPw/uLTIBGIHZ7BPFl4por0mAxlcUDLnuogFAsR4FxktW
	 qWqoWx3bpfAukemVNqY5Gd1yVS+fr0qLTs8342hUebt+VDdDC0pZbKDgmVXCRAsR5W
	 wT10Kc+ZEayXp2mqrGu8e9Fo7TwG0fMHXT3ocxbSeHxEnbNyjtOPP71CyGvPP6QYGY
	 jkbF4ah40MXMwfSnhD6W9dUXWNRpCcWkWVn/ejhQJpUiLwg9Cgemh04EStI7YVI2LR
	 Btv5dC5YsfndA==
Message-ID: <cde7f3ae-917f-41ec-93e5-69eb656370e8@kernel.org>
Date: Wed, 20 Dec 2023 10:31:29 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] t/zbd: add test case to confirm no write with
 rwmixwrite=0 option
Content-Language: en-US
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
Cc: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
 Niklas Cassel <niklas.cassel@wdc.com>
References: <20231220005846.1371456-1-shinichiro.kawasaki@wdc.com>
 <20231220005846.1371456-3-shinichiro.kawasaki@wdc.com>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20231220005846.1371456-3-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/20/23 09:58, Shin'ichiro Kawasaki wrote:
> The previous commit fixed the issue of the unexpected write with options
> zonemode=zbd, rw=randrw and rwmixwrite=0. Add a test to confirm the fix.
> 
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  t/zbd/test-zbd-support | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
> index 2f15a191..532860eb 100755
> --- a/t/zbd/test-zbd-support
> +++ b/t/zbd/test-zbd-support
> @@ -1561,6 +1561,29 @@ test67() {
>  	grep -q 'Exceeded max_active_zones limit' "${logfile}.${test_number}"
>  }
>  
> +# Test rw=randrw and rwmixwrite=0 options do not issue write I/O unit
> +test68() {
> +	local off size
> +
> +	require_zbd || return "$SKIP_TESTCASE"
> +
> +	reset_zone "${dev}" -1
> +
> +	# Write some data as preparation
> +	off=$((first_sequential_zone_sector * 512))
> +	size=$min_seq_write_size
> +	run_one_fio_job "$(ioengine "psync")" --rw=write --offset="$off" \
> +			--io_size="$size" --zonemode=strided \
> +			--zonesize="$zone_size" --zonerange="$zone_size" \
> +		       >> "${logfile}.${test_number}" 2>&1 || return $?
> +	# Run random mixed read and write specifying zero write ratio
> +	run_fio_on_seq "$(ioengine "psync")" --rw=randrw --rwmixwrite=0 \
> +		       --time_based --runtime=1s \
> +		       >> "${logfile}.${test_number}" 2>&1 || return $?
> +	# "WRITE:" shall be recoreded only once for the preparation
> +	[[ $(grep -c "WRITE:" "${logfile}.${test_number}") == 1 ]]
> +}
> +
>  SECONDS=0
>  tests=()
>  dynamic_analyzer=()

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

