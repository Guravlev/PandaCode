
<?php echo $header; ?>
<div id="content">
    <div class="breadcrumb">
        <?php foreach ($breadcrumbs as $breadcrumb) { ?>
        <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
        <?php } ?>
    </div>
    <?php if ($error_warning) { ?>
    <div class="warning"><?php echo $error_warning; ?></div>
    <?php } ?>
    <div class="box">
        <div class="heading">
            <h1><img src="view/image/module.png" alt="" /> <?php echo $heading_title; ?></h1>
            <div class="buttons"><a onclick="$('#form').submit();" class="button"><?php echo $button_save; ?></a><a href="<?php echo $cancel; ?>" class="button"><?php echo $button_cancel; ?></a></div>
        </div>
        <div class="content">
            <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form">
                <table id="module" class="list">
                    <thead>
                    <tr>
                        <td class="left"><?php echo $entry_name; ?></td>
                        <td class="left"><?php echo $entry_banner_image; ?></td>
                        <td class="left"><?php echo $entry_image; ?></td>
                        <td class="left"><?php echo $entry_description; ?></td>
                        <td class="left"><?php echo $entry_category; ?></td>
                        <td class="left"><?php echo $entry_layout; ?></td>
                        <td class="left"><?php echo $entry_position; ?></td>
                        <td class="left"><?php echo $entry_status; ?></td>
                        <td class="right"><?php echo $entry_sort_order; ?></td>
                        <td></td>
                    </tr>
                    </thead>
                    <?php $module_row = 0; ?>
                    <script>
                        function autocompl(id) {

                            $("#newModuleCategory" + id).autocomplete({
                                delay: 500,
                                source: function(request, response) {
                                    $.ajax({
                                        url: 'index.php?route=module/newBanner/autocomplete&token=<?php echo $token; ?>&filter_name=' +  encodeURIComponent(request.term),
                                        dataType: 'json',
                                        success: function(json) {
                                            response($.map(json, function(item) {
                                                return {
                                                    label: item.name,
                                                    value: item.category_id
                                                }
                                            }));
                                        }
                                    });
                                },

                                select: function(event, ui) {


                                    $('#category-related' + ui.item.value).remove();
                                    $('#category-related'+ id).append('<div id="category-related' + ui.item.value + '">' + ui.item.label + '<img class="remove-category" src="view/image/delete.png" alt="" /><input type="hidden" name="newBanner_module[<?php echo $module_row; ?>][category_related]" value="' + ui.item.value + '" /></div>');

                                    $('#category-related'+ id+' div:odd').attr('class', 'odd');
                                    $('#category-related'+ id+' div:even').attr('class', 'even');

                                    return false;
                                },
                                focus: function(event, ui) {
                                    return false;
                                }
                            });
                            $('#form').on('click', '.remove-category', function () {

                                $(this).parent().remove();
                                $(this).parents('newBannerScrollbox').find('div:odd');
                                $(this).parents('newBannerScrollbox').find('div:even');

                            });
                        }
                    </script>
                    <?php foreach ($modules as $module) { ?>
                    <tbody id="module-row<?php echo $module_row; ?>">
                    <tr>
                        <td class="left">
                            <input type="text" name="newBanner_module[<?php echo $module_row; ?>][name]" value="<?php echo $module['name']?>" size="10" />
                        </td>
                        <td class="left">
                            <div class="image">
                                <img src="<?php echo $module['image']; ?>" alt="" id="thumb<?php echo $module_row; ?>" /><br />
                                <input type="hidden" name="newBanner_module[<?php echo $module_row; ?>][image]" value="<?php echo $module['thumb'] ?>" id="image<?php echo $module_row; ?>" />
                                <a onclick="image_upload('image<?php echo $module_row; ?>', 'thumb<?php echo $module_row; ?>');">
                                    <?php echo $text_browse; ?>
                                </a>&nbsp;&nbsp;|&nbsp;&nbsp;
                                <a onclick="$('#thumb<?php echo $module_row; ?>').attr('src', '');
                                            $('#image<?php echo $module_row; ?>').attr('value', '');">
                                    <?php echo $text_clear; ?>
                                </a>
                            </div>
                        </td>
                        <td class="left"><input type="text" name="newBanner_module[<?php echo $module_row; ?>][image_width]" value="<?php echo $module['image_width']; ?>" size="3" />
                            <input type="text" name="newBanner_module[<?php echo $module_row; ?>][image_height]" value="<?php echo $module['image_height']; ?>" size="3" />
                            <?php if (isset($error_image[$module_row])) { ?>
                            <span class="error"><?php echo $error_image[$module_row]; ?></span>
                            <?php } ?></td>
                        <td class="left">
                            <textarea name="newBanner_module[<?php echo $module_row; ?>][description]" id="description<?php echo $module_row; ?>">
                                <?php echo ($module['description']); ?>
                            </textarea>
                        </td>
                        <td class="left"><input type="text" name="newBanner_module[<?php echo $module_row; ?>]" value="" id="newModuleCategory<?php echo $module_row; ?>" /></br></br>
                            <div id="category-related<?php echo $module_row; ?>" class="newBannerScrollbox">
                                <?php $class = 'odd'; ?>
                                <?php foreach ($category_related as $category_related) { ?>
                                <?php $class = ($class == 'even' ? 'odd' : 'even'); ?>
                                <div id="category-related<?php echo $category_related['category_id']; ?>" class="<?php echo $class; ?>">
                                    <?php echo $category_related['name']; ?>
                                    <img src="view/image/delete.png" class="remove-category" alt="" />
                                    <input type="hidden" name="newBanner_module[<?php echo $module_row; ?>][category_related]" value="<?php echo $category_related['category_id']; ?>" />
                                </div>
                                <?php } ?>
                            </div>
                        </td>

                        <td class="left"><select name="newBanner_module[<?php echo $module_row; ?>][layout_id]">
                                <?php foreach ($layouts as $layout) { ?>
                                <?php if ($layout['layout_id'] == $module['layout_id']) { ?>
                                <option value="<?php echo $layout['layout_id']; ?>" selected="selected"><?php echo $layout['name']; ?></option>
                                <?php } else { ?>
                                <option value="<?php echo $layout['layout_id']; ?>"><?php echo $layout['name']; ?></option>
                                <?php } ?>
                                <?php } ?>
                            </select></td>
                        <td class="left"><select name="newBanner_module[<?php echo $module_row; ?>][position]">
                                <?php if ($module['position'] == 'content_top') { ?>
                                <option value="content_top" selected="selected"><?php echo $text_content_top; ?></option>
                                <?php } else { ?>
                                <option value="content_top"><?php echo $text_content_top; ?></option>
                                <?php } ?>
                                <?php if ($module['position'] == 'content_bottom') { ?>
                                <option value="content_bottom" selected="selected"><?php echo $text_content_bottom; ?></option>
                                <?php } else { ?>
                                <option value="content_bottom"><?php echo $text_content_bottom; ?></option>
                                <?php } ?>
                                <?php if ($module['position'] == 'column_left') { ?>
                                <option value="column_left" selected="selected"><?php echo $text_column_left; ?></option>
                                <?php } else { ?>
                                <option value="column_left"><?php echo $text_column_left; ?></option>
                                <?php } ?>
                                <?php if ($module['position'] == 'column_right') { ?>
                                <option value="column_right" selected="selected"><?php echo $text_column_right; ?></option>
                                <?php } else { ?>
                                <option value="column_right"><?php echo $text_column_right; ?></option>
                                <?php } ?>
                            </select></td>
                        <td class="left"><select name="newBanner_module[<?php echo $module_row; ?>][status]">
                                <?php if ($module['status']) { ?>
                                <option value="1" selected="selected"><?php echo $text_enabled; ?></option>
                                <option value="0"><?php echo $text_disabled; ?></option>
                                <?php } else { ?>
                                <option value="1"><?php echo $text_enabled; ?></option>
                                <option value="0" selected="selected"><?php echo $text_disabled; ?></option>
                                <?php } ?>
                            </select></td>
                        <td class="right"><input type="text" name="newBanner_module[<?php echo $module_row; ?>][sort_order]" value="<?php echo $module['sort_order']; ?>" size="3" /></td>
                        <td class="left"><a onclick="$('#module-row<?php echo $module_row; ?>').remove();" class="button"><?php echo $button_remove; ?></a></td>
                    </tr>
                    </tbody>
                        <script>
                            autocompl(<?php echo $module_row; ?>);
                        </script>
                    <?php $module_row++; ?>
                    <?php } ?>
                    <tfoot>
                    <tr>
                        <td colspan="9"></td>
                        <td class="left"><a onclick="addModule();" class="button"><?php echo $button_add_module; ?></a></td>
                    </tr>
                    </tfoot>
                </table>
            </form>
        </div>
    </div>
</div>


<script type="text/javascript"><!--
    // Related

    //--></script>

<script type="text/javascript"><!--
    function image_upload(field, thumb) {
        $('#dialog').remove();

        $('#content').prepend('<div id="dialog" style="padding: 3px 0px 0px 0px;"><iframe src="index.php?route=common/filemanager&token=<?php echo $token; ?>&field=' + encodeURIComponent(field) + '" style="padding:0; margin: 0; display: block; width: 100%; height: 100%;" frameborder="no" scrolling="auto"></iframe></div>');

        $('#dialog').dialog({
            title: '<?php echo $text_module_image_manager; ?>',
            close: function (event, ui) {
                if ($('#' + field).attr('value')) {
                    $.ajax({
                        url: 'index.php?route=common/filemanager/image&token=<?php echo $token; ?>&image=' + encodeURIComponent($('#' + field).attr('value')),
                        dataType: 'text',
                        success: function(text) {
                            $('#' + thumb).replaceWith('<img src="' + text + '" alt="" id="' + thumb + '" />');
                        }
                    });
                }
            },
            bgiframe: false,
            width: 800,
            height: 400,
            resizable: false,
            modal: false
        });
    };
    //--></script>

<script type="text/javascript"><!--
    var module_row = <?php echo $module_row; ?>;

    function addModule() {
        html  = '<tbody id="module-row' + module_row + '">';
        html += '  <tr>';
        html += '    <td class="left"><input type="text" name="newBanner_module[' + module_row + '][name]" value="" size="10" /></td>';
        html += '     <td class="left">';
        html += '       <div class="image">';
        html += '           <img src="<?php echo $no_image; ?>" alt="" id="thumb' + module_row + '" />';
        html += '           <input type="hidden" name="newBanner_module[' + module_row + '][image]" value="" id="image' + module_row + '" />';
        html += '           <br />';
        html += '           <a onclick="image_upload(\'image' + module_row + '\', \'thumb' + module_row + '\');"><?php echo $text_browse; ?></a>&nbsp;&nbsp;|&nbsp;&nbsp;';
        html += '           <a onclick="$(\'#thumb' + module_row + '\').attr(\'src\', \'<?php echo $no_image; ?>\'); $(\'#image' + module_row + '\').attr(\'value\', \'\');"><?php echo $text_clear; ?></a>';
        html += '       </div>';
        html += '     </td>';
        html += '    <td class="left"><input type="text" name="newBanner_module[' + module_row + '][image_width]" value="80" size="3" /> <input type="text" name="newBanner_module[' + module_row + '][image_height]" value="80" size="3" /></td>';

        html += '   <td class="left">';
        html += '   <textarea name="newBanner_module[' + module_row + '][description]" id="description' + module_row + '">';
        html += '   </textarea>';
        html += '   </td>';

        html += '   <td class="left"><input type="text" name="newBanner_module[' + module_row + ']" value="" id="newModuleCategory' + module_row + '" /></br></br>';
        html += '    <div id="category-related' + module_row + '" class="newBannerScrollbox">';
        html += '    </div>';
        html += '    </td>';

        html += '    <td class="left"><select name="newBanner_module[' + module_row + '][layout_id]">';
    <?php foreach ($layouts as $layout) { ?>
            html += '      <option value="<?php echo $layout['layout_id']; ?>"><?php echo addslashes($layout['name']); ?></option>';
        <?php } ?>
        html += '    </select></td>';
        html += '    <td class="left"><select name="newBanner_module[' + module_row + '][position]">';
        html += '      <option value="content_top"><?php echo $text_content_top; ?></option>';
        html += '      <option value="content_bottom"><?php echo $text_content_bottom; ?></option>';
        html += '      <option value="column_left"><?php echo $text_column_left; ?></option>';
        html += '      <option value="column_right"><?php echo $text_column_right; ?></option>';
        html += '    </select></td>';
        html += '    <td class="left"><select name="newBanner_module[' + module_row + '][status]">';
        html += '      <option value="1" selected="selected"><?php echo $text_enabled; ?></option>';
        html += '      <option value="0"><?php echo $text_disabled; ?></option>';
        html += '    </select></td>';
        html += '    <td class="right"><input type="text" name="newBanner_module[' + module_row + '][sort_order]" value="" size="3" /></td>';
        html += '    <td class="left"><a onclick="$(\'#module-row' + module_row + '\').remove();" class="button"><?php echo $button_remove; ?></a></td>';
        html += '  </tr>';
        html += '</tbody>';

        $('#module tfoot').before(html);
        autocompl(module_row);

        module_row++;
    }
    //--></script>

<?php echo $footer; ?>