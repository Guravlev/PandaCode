<?php
class ControllerModuleNewBanner extends Controller{
    private $error = array();

    /**
     *
     */
    public function index() {
        $this->language->load('module/newBanner');

        $this->document->setTitle($this->language->get('heading_title'));

        $this->load->model('setting/setting');

        if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate()) {
            $this->model_setting_setting->editSetting('newBanner', $this->request->post);
            echo "<pre>";
            echo "postik";
            print_r($_POST);die;
            $this->session->data['success'] = $this->language->get('text_success');

            $this->redirect($this->url->link('extension/module', 'token=' . $this->session->data['token'], 'SSL'));

        }

        $this->data['heading_title'] = $this->language->get('heading_title');
;
        $this->data['entry_product'] = $this->language->get('entry_product');
        $this->data['entry_limit'] = $this->language->get('entry_limit');
        $this->data['entry_name'] = $this->language->get('entry_name');
        $this->data['entry_banner_image'] = $this->language->get('entry_banner_image');
        $this->data['entry_image'] = $this->language->get('entry_image');
        $this->data['entry_description'] = $this->language->get('entry_description');
        $this->data['entry_category'] = $this->language->get('entry_category');
        $this->data['entry_layout'] = $this->language->get('entry_layout');
        $this->data['entry_position'] = $this->language->get('entry_position');
        $this->data['entry_status'] = $this->language->get('entry_status');
        $this->data['entry_sort_order'] = $this->language->get('entry_sort_order');
        $this->data['text_browse'] = $this->language->get('text_browse');
        $this->data['text_clear'] = $this->language->get('text_clear');

        $this->data['button_save'] = $this->language->get('button_save');
        $this->data['button_cancel'] = $this->language->get('button_cancel');
        $this->data['button_add_module'] = $this->language->get('button_add_module');
        $this->data['button_remove'] = $this->language->get('button_remove');

        if (isset($this->error['warning'])) {
            $this->data['error_warning'] = $this->error['warning'];
        } else {
            $this->data['error_warning'] = '';
        }

        if (isset($this->error['image'])) {
            $this->data['error_image'] = $this->error['image'];
        } else {
            $this->data['error_image'] = array();
        }

        $this->data['breadcrumbs'] = array();

        $this->data['breadcrumbs'][] = array(
            'text'      => $this->language->get('text_home'),
            'href'      => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),
            'separator' => false
        );

        $this->data['breadcrumbs'][] = array(
            'text'      => $this->language->get('text_module'),
            'href'      => $this->url->link('extension/module', 'token=' . $this->session->data['token'], 'SSL'),
            'separator' => ' :: '
        );

        $this->data['breadcrumbs'][] = array(
            'text'      => $this->language->get('heading_title'),
            'href'      => $this->url->link('module/newBanner', 'token=' . $this->session->data['token'], 'SSL'),
            'separator' => ' :: '
        );

        $this->data['action'] = $this->url->link('module/newBanner', 'token=' . $this->session->data['token'], 'SSL');

        $this->data['cancel'] = $this->url->link('extension/module', 'token=' . $this->session->data['token'], 'SSL');

        $this->data['token'] = $this->session->data['token'];

        if (isset($this->request->post['newBanner_product'])) {
            $this->data['newBanner_product'] = $this->request->post['newBanner_product'];
        } else {
            $this->data['newBanner_product'] = $this->config->get('newBanner_product');
        }
       
        //$this->data['modules'] = array();

        if (isset($this->request->post['newBanner_module'])) {
            $modules = $this->request->post['newBanner_module'];
        } elseif ($this->config->get('newBanner_module')) {
            $modules = $this->config->get('newBanner_module');
        }

        $this->data['token'] = $this->session->data['token'];

        $this->data['modules'] = array();

        $this->load->model('tool/image');

        $this->load->model('catalog/category');
        

        
        foreach ($modules as $module) {
            print_r( $module);
            if (!empty($module['image']) && file_exists(DIR_IMAGE . $module['image'])) {
                $image = $this->model_tool_image->resize($module['image'], 100, 100);
            }else {
                 $image = $this->model_tool_image->resize('no_image.jpg', 100, 100);
            }

            $this->data['no_image'] = $this->model_tool_image->resize('no_image.jpg', 100, 100);


            $this->data['modules'][] = array(
                'name'              =>$module['name'],
                'image'             =>$image,
                'thumb'             =>$module['image'],
                'image_width'       =>$module['image_width'],
                'image_height'      =>$module['image_height'],
                'description'       =>$module['description'],
                'category_related'  =>$module['category_related'],
                'layout_id'         =>$module['layout_id'],
                'position'          =>$module['position'],
                'status'            =>$module['status'],
                'sort_order'        =>$module['sort_order'],
            );//print_r(  $this->data['modules']);

        }

        $this->data['category_related'] = array();

        foreach ($this->data['modules'] as $elements) {
            $category_id =  $elements['category_related'] ;
            $related_info = $this->model_catalog_category->getCategory($category_id);

            if ($related_info) {
                $this->data['category_related'][] = array(
                    'category_id' => $related_info['category_id'],
                    'name' => $related_info['name']
                );
            }
        }
        
        //$this->load->model('localisation/language');

        $this->load->model('design/layout');

        $this->data['layouts'] = $this->model_design_layout->getLayouts();

        $this->template = 'module/newBanner.tpl';
        $this->children = array(
            'common/header',
            'common/footer'
        );

        $this->response->setOutput($this->render());
    }

    protected function validate() {
        if (!$this->user->hasPermission('modify', 'module/new_banner')) {
            $this->error['warning'] = $this->language->get('error_permission');
        }


//        if (isset($this->request->post['newBanner_module'])) {
//            foreach ($this->request->post['newBanner_module'] as $key => $value) {
//                if (!$value['image_width'] || !$value['image_height']) {
//                    $this->error['image'][$key] = $this->language->get('error_image');
//                }else{
//                    $this->error['image'][$key] = false;
//                }
//            }
//        }

        if (!$this->error) {
            return true;
        } else {
            return false;
        }


    }


        public function autocomplete() {
            $json = array();

            if (isset($this->request->get['filter_name'])) {
                $this->load->model('catalog/category');

                $data = array(
                    'filter_name' => $this->request->get['filter_name'],
                    'start'       => 0,
                    'limit'       => 20
                );

                $filters = $this->model_catalog_category->getCategories($data);

                foreach ($filters as $filter) {
                    $json[] = array(
                        'category_id' => $filter['category_id'],
                        'name'      => strip_tags(html_entity_decode($filter['name'], ENT_QUOTES, 'UTF-8'))
                    );
                }
            }

            $sort_order = array();

            foreach ($json as $key => $value) {
                $sort_order[$key] = $value['name'];
            }

            array_multisort($sort_order, SORT_ASC, $json);

            $this->response->setOutput(json_encode($json));
        }

}
?>