<?php
class ControllerModuleNewBanner extends Controller {

    protected function index($setting) {
        $this->language->load('module/newBanner');

        $this->data['heading_title'] = $this->language->get('heading_title');

        $this->data['button_cart'] = $this->language->get('button_cart');

        $this->load->model('catalog/product');

        $this->load->model('tool/image');

        $this->data['newBanner_module'] = array();

//print_r($setting);
        if( !empty($setting)) {

            if (!empty($setting['image'])) {
                $image = $this->model_tool_image->resize($setting['image'], $setting['image_width'], $setting['image_height']);
            } else {
                $image = false;
            }
            if (!empty($setting['name'])) {
                $name = $setting['name'];
            } else {
                $name = false;
            }
            if (!empty($setting['category_id'])) {
                $category = $setting['category_id'];
            } else {
                $category = false;
            }
            if (!empty($setting['description'])) {
                $description = $setting['description'];
            } else {
                $description = false;
            }

            $this->data['no_image'] = $this->model_tool_image->resize('no_image.jpg', 100, 100);

            $this->data['newBanners'][] = array(
                'name'       => $name,
                'image'      => $image,
                'description'=> $description,
                'category_id'=> $category,
                'href'    	 => $this->url->link('product/category', 'path=' . $category)
            );
        }


        if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/module/newBanner.tpl')) {
            $this->template = $this->config->get('config_template') . '/template/module/newBanner.tpl';
        } else {
            $this->template = 'default/template/module/newBanner.tpl';
        }
        
        $this->render();
    }
}
?>