<div class="box">
    <div class="box-heading"><?php echo $heading_title; ?></div>
    <div class="box-content">
        <div class="box-product">
            <?php foreach ($newBanners as $newBanner) { ?>
            <div>
                <div><php echo $newBanner ?></div>
                <?php if ($newBanner['image']) { ?>
                <div class="image">
                    <a href="<?php echo $newBanner['href']; ?>">
                        <img src="<?php echo $newBanner['image']; ?>" alt="<?php echo $newBanner['name']; ?>" />
                        <span class="newBanner_name"><?php echo $newBanner['description']; ?></span>
                    </a>
                </div>
                <div class="name">
                    <span><?php echo $newBanner['name']; ?></span>
                </div>
                <?php } ?>


            </div>
            <?php } ?>
        </div>
    </div>
</div>
