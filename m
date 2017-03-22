Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52766 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758035AbdCVDvS (ORCPT
        <rfc822;fio@vger.kernel.org>); Tue, 21 Mar 2017 23:51:18 -0400
Subject: Re: [PATCH] Ensure all json field keys do not have ' ' in them
References: <20170321211632.38104-1-gwendal@chromium.org>
From: Jens Axboe <axboe@fb.com>
Message-ID: <8709584e-1ea6-e031-a0dc-5a9d8ec915ce@fb.com>
Date: Tue, 21 Mar 2017 23:51:09 -0400
MIME-Version: 1.0
In-Reply-To: <20170321211632.38104-1-gwendal@chromium.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Gwendal Grignou <gwendal@chromium.org>
Cc: fio@vger.kernel.org

On 03/21/2017 05:16 PM, Gwendal Grignou wrote:
> So far, fio key names use '_' instead of ' '.
> Fix keys with 'job options' and 'global options' to match the naming
> convention.

Is there a problem with the outputted json? I agree it would be
cleaner to have the underscore instead of the space, but this
change might also break scripts that parse the existing
output. So we need a good reason to change it, which isn't
just a cosmetic concern.

Just curious what your motivations are for the change.

-- 
Jens Axboe

