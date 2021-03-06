<div id="gift_cert_verify">
{if $verify_data}

<div class="ty-gift-certificate-verify gift-verify">
{** /Gift certificates section **}
{capture name="tabsbox"}
<div id="content_detailed" class="hidden">
    {include file="common/subheader.tpl" title=__("gift_certificate_info")}
    <table class="ty-gift-certificate-verify__table gift-verify-table">
        <tr>
            <td class="ty-gift-certificate-verify__row"><strong>{__("gift_cert_code")}:</strong></td>
            <td class="ty-gift-certificate-verify__row"><strong>{$verify_data.gift_cert_code}</strong></td>
        </tr>
        <tr>
            <td class="ty-gift-certificate-verify__row"><strong>{__("status")}:</strong></td>
            <td class="ty-gift-certificate-verify__row">{include file="common/status.tpl" status=$verify_data.status display="view" status_type=$smarty.const.STATUSES_GIFT_CERTIFICATE}</td>
        </tr>
        <tr>
            <td class="ty-gift-certificate-verify__row"><strong>{__("gift_cert_to")}:</strong></td>
            <td class="ty-gift-certificate-verify__row">{$verify_data.recipient}</td>
        </tr>
        <tr>
            <td class="ty-gift-certificate-verify__row"><strong>{__("gift_cert_from")}:</strong></td>
            <td class="ty-gift-certificate-verify__row">{$verify_data.sender}</td>
        </tr>
        <tr>
            <td class="ty-gift-certificate-verify__row"><strong>{__("amount")}:</strong></td>
            <td class="ty-gift-certificate-verify__row">{include file="common/price.tpl" value=$verify_data.amount}</td>
        </tr>
    </table>


    {if $addons.gift_certificates.free_products_allow == "Y" && $verify_data.products}
    {include file="common/subheader.tpl" title=__("free_products")}
    <table class="ty-gift-certificate-verify__table ty-table">
        <thead>
            <tr>
                <th style="width: 90%">{__("product")}</th>
                <th>{__("quantity")}</th>
            </tr>
        </thead>
        {foreach from=$verify_data.products item="product_item"}
        <tr>
            <td>
            <a href="{"products.view?product_id=`$product_item.product_id`"|fn_url}">{$product_item.product|default:__("deleted_product")}</a>
            {include file="common/options_info.tpl" product_options=$product_item.product_options_value}
            </td>
            <td class="ty-center">{$product_item.amount}</td>
        </tr>
        {foreachelse}
        <tr class="ty-table__no-items">
            <td colspan="2"><p class="ty-no-items">{__("no_items")}</p></td>
        </tr>
        {/foreach}
    </table>

    {if $verify_data.status == "A"}
        <div class="ty-gift-certificate__buttons buttons-container">
            <form name="gift_certificate_apply_form" method="post" action="{fn_url()}">
                <input type="hidden" name="coupon_code" value="{$verify_data.gift_cert_code}">
                <div class="ty-float-right ty-gift-certificate__preview-btn">
                    {include file="buttons/button.tpl" but_text=__("gc_redeem_and_add_free_products") but_name="dispatch[checkout.apply_coupon]" but_role="submit" but_meta="ty-btn__tertiary"}
                </div>
            </form>
        </div>
    {/if}

    {/if}

</div>
<div id="content_log" class="hidden">
    {include file="common/pagination.tpl"}

    {assign var="c_url" value=$config.current_url|fn_query_remove:"sort_by":"sort_order"}
    {if $search.sort_order == "asc"}
        {include_ext file="common/icon.tpl" class="ty-icon-down-dir" assign=sort_sign}
    {else}
        {include_ext file="common/icon.tpl" class="ty-icon-up-dir" assign=sort_sign}
    {/if}

    <table class="ty-table ty-gift-certificate-history">
        <thead>
            <tr>
                <th><a class="cm-ajax" href="{"`$c_url`&sort_by=timestamp&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("date")}</a>{if $search.sort_by === "timestamp"}{$sort_sign nofilter}{/if}</th>
                <th ><a class="cm-ajax" href="{"`$c_url`&sort_by=name&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("customer")}</a>{if $search.sort_by === "name"}{$sort_sign nofilter}{/if}</th>
                <th ><a class="cm-ajax" href="{"`$c_url`&sort_by=amount&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("balance")}</a>{if $search.sort_by === "amount"}{$sort_sign nofilter}{/if}</th>
                <th ><a class="cm-ajax" href="{"`$c_url`&sort_by=debit&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id="pagination_contents">{__("gift_cert_debit")}</a>{if $search.sort_by === "debit"}{$sort_sign nofilter}{/if}</th>
            </tr>
        </thead>
    {foreach from=$log item="l"}
    <tr>
        <td style="width: 30px;">{$l.timestamp|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}</td>
        <td>
            <p>
            {if $l.user_id}
                {$l.firstname} {$l.lastname}
            {elseif $l.order_id}
                {$l.order_firstname} {$l.order_lastname}
            {/if}
            </p>
            <p>
            {if $l.user_id}
                <a href="mailto:{$l.email|escape:url}">{$l.email}</a>
            {else}
                <a href="mailto:{$l.order_email|escape:url}">{$l.order_email}</a>
            {/if}
            </p>
        </td>
        <td>
            {if $addons.gift_certificates.free_products_allow == "Y"}{__("amount")}:&nbsp;{/if}{include file="common/price.tpl" value=$l.amount}
            {if $l.products && $addons.gift_certificates.free_products_allow == "Y"}
                <p>{__("free_products")}:</p>
                <ol>
                    {foreach from=$l.products item="product_item"}
                        <li>{if $product_item.product}<a href="{"products.view?product_id=`$product_item.product_id`"|fn_url}">{$product_item.product|truncate:30:"...":true}</a>{else}{__("deleted_product")}{/if}<span>({$product_item.amount})</span></li>
                    {/foreach}
                </ol>
            {/if}
        </td>
        <td>
            {if $addons.gift_certificates.free_products_allow == "Y"}{__("amount")}:&nbsp;{/if}{include file="common/price.tpl" value=$l.debit}
            {if $l.debit_products && $addons.gift_certificates.free_products_allow == "Y"}
                <p>{__("free_products")}:</p>
                <ol>
                    {foreach from=$l.debit_products item="product_item"}
                        <li>{$product_item.amount} - {if $product_item.product}<a href="{"products.view?product_id=`$product_item.product_id`"|fn_url}">{$product_item.product|truncate:30:"...":true}</a>{else}{__("deleted_product")}{/if}</li>
                    {/foreach}
                </ol>
            {/if}
        </td>
        </tr>
        {foreachelse}
        <tr class="ty-table__no-items">
            <td colspan="5"><p class="ty-no-items">{__("no_items")}</p></td>
        </tr>
        {/foreach}
        </table>
        {include file="common/pagination.tpl"}
    </div>
    {/capture}
    {include file="common/tabsbox.tpl" content=$smarty.capture.tabsbox active_tab=$smarty.request.selected_section}

</div>

{else}
    <div class="ty-gift-certificate-verify__error">{__("error_gift_cert_code")}</div>
{/if}

{** /Gift certificates section **}
<!--gift_cert_verify--></div>
{capture name="mainbox_title"}{__("gift_certificate_verification")}{/capture}
