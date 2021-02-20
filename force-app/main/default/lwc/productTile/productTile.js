import { LightningElement, api } from 'lwc';

/**
 * A presentation component to display a Product2 sObject. The provided
 * Product2 data must contain all fields used by this component.
 */
export default class ProductTile extends LightningElement {
    /** Whether the tile is draggable. */
    @api draggable;

    _product;
    
    @api
    get product() {
        return this._product;
    }
    set product(value) {
        this._product = value;
        this.pictureUrl = value.Picture_URL__c;
        this.name = value.Name;
        this.msrp = value.MSRP__c;
    }

    /** Product2 field values to display. */
    pictureUrl;
    name;
    msrp;

    handleClick() {
        const selectedEvent = new CustomEvent('selected', {
            detail: this.product.Id
        });
        this.dispatchEvent(selectedEvent);
    }

    handleDragStart(event) {
        event.dataTransfer.setData('product', JSON.stringify(this.product));
    }
}